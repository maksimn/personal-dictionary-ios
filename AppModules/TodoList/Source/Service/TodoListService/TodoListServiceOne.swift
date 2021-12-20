//
//  TodoItemCRUDModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 30.06.2021.
//

import CoreModule
import Foundation

/// Общая логика отправки и обработки сетевых запросов создания, обновления и удаления todo item'a.
class TodoListServiceOne: TodoListService {

    private let cache: TodoListCache
    private let logger: Logger
    private let networking: NetworkingService
    private let сounter: HttpRequestCounter

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    init(cache: TodoListCache,
         logger: Logger,
         networking: NetworkingService,
         сounter: HttpRequestCounter) {
        self.cache = cache
        self.logger = logger
        self.networking = networking
        self.сounter = сounter
    }

    var cachedTodoList: [TodoItem] {
        cache.todoList
    }

    var areRequestsPending: Bool {
        сounter.areRequestsPending
    }

    func fetchRemoteTodoList(_ completion: @escaping (Error?) -> Void) {
        if cache.isDirty {
            mergeWithRemote(completion)
        } else {
            logger.networkRequestStart(RequestType.getTodoList)
            сounter.increment()
            networking.fetchTodoList { [weak self] result in
                self?.сounter.decrement()
                do {
                    self?.logger.networkRequestSuccess(RequestType.getTodoList)

                    let fetchedTodoList = try result.get().map { $0.map() }
                    let mergedTodoList = self?.cachedTodoList.mergeWith(fetchedTodoList) ?? []
                    self?.cache.replaceWith(mergedTodoList) { error in
                        completion(error)
                    }
                } catch {
                    self?.logger.log(error: error)
                    completion(error)
                }
            }
        }
    }

    func createRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        if cache.isDirty {
            cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }

            return
        }

        logger.networkRequestStart(RequestType.createTodoItem)
        сounter.increment()
        cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.createTodoItem(TodoItemDTO.map(todoItem)) { [weak self] result in
                self?.сounter.decrement()

                do {
                    _ = try result.get()

                    self?.logger.networkRequestSuccess(RequestType.createTodoItem)
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.logger.log(error: error)
                    self?.handleNetworkRequestError(item: todoItem, deleted: false, completion)
                }
            }
        }
    }

    func updateRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        if cache.isDirty {
            cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }

            return
        }

        logger.networkRequestStart(RequestType.updateTodoItem)
        сounter.increment()
        cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.updateTodoItem(TodoItemDTO.map(todoItem)) { [weak self] result in
                self?.сounter.decrement()
                do {
                    _ = try result.get()

                    self?.logger.networkRequestSuccess(RequestType.updateTodoItem)
                    self?.cache.update(todoItem.update(isDirty: false)) { _ in
                        completion(nil)
                    }
                } catch {
                    self?.logger.log(error: error)
                    self?.handleNetworkRequestError(item: todoItem, deleted: false, completion)
                }
            }
        }
    }

    func removeRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        cache.delete(todoItem) { [weak self] _ in
            self?.removeRemoteRequest(todoItem, completion)
        }
    }

    func mergeWithRemote(_ completion: @escaping (Error?) -> Void) {
        let deleted = Array(Set(cache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.todoList.filter { $0.isDirty }.map { TodoItemDTO.map($0) }
        let requestData = MergeTodoListRequestData(deleted: deleted, other: dirtyItems)

        logger.networkRequestStart(RequestType.mergeTodoList)
        сounter.increment()
        networking.mergeTodoList(requestData) { [weak self] result in
            self?.сounter.decrement()
            do {
                var todoList = try result.get().map({ $0.map() })
                todoList.sortByCreateAt()
                self?.logger.networkRequestSuccess(RequestType.mergeTodoList)
                self?.cache.clearTombstones { _ in

                }
                self?.currentDelay = TodoListServiceOne.minDelay
                self?.cache.replaceWith(todoList) { error in
                    NotificationCenter.default.post(name: .mergeTodoListWithRemoteSuccess, object: nil)
                    completion(error)
                }
            } catch {
                self?.logger.log(error: error)
                self?.retryMergeRequestAfterDelay(completion)
            }
        }
    }

    private func removeRemoteRequest(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

        if cache.isDirty {
            cache.insert(tombstone: tombstone) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }
        } else {
            logger.networkRequestStart(RequestType.deleteTodoItem)
            сounter.increment()
            cache.insert(tombstone: tombstone) { [weak self] _ in
                self?.networking.deleteTodoItem(todoItem.id) { [weak self] result in
                    self?.сounter.decrement()
                    do {
                        _ = try result.get()

                        self?.logger.networkRequestSuccess(RequestType.deleteTodoItem)
                        self?.cache.clearTombstones { _ in
                            completion(nil)
                        }
                    } catch {
                        self?.logger.log(error: error)
                        self?.handleNetworkRequestError(item: todoItem, deleted: true, completion)
                    }
                }
            }
        }
    }

    private func handleNetworkRequestError(item: TodoItem, deleted: Bool, _ completion: @escaping (Error?) -> Void) {
        if !deleted {
            cache.update(item.update(isDirty: true)) { [weak self] _ in
                self?.retryMergeRequestAfterDelay(completion)
            }
        } else {
            self.retryMergeRequestAfterDelay(completion)
        }
    }

    private func retryMergeRequestAfterDelay(_ completion: @escaping (Error?) -> Void) {
        retryMergeRequestAfter(delay: currentDelay, completion)
        currentDelay = nextDelay
    }

    private func retryMergeRequestAfter(delay: Double, _ completion: @escaping (Error?) -> Void) {
        let seconds: Int = Int(delay)
        let milliseconds: Int = Int((delay - Double(seconds)) * Double(1000))
        let deadlineTime = DispatchTime.now() + .seconds(seconds) + .milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.mergeWithRemote(completion)
        }
    }

    private var nextDelay: Double {
        let delay = min(currentDelay * TodoListServiceOne.factor, TodoListServiceOne.maxDelay)
        let next = delay + delay * TodoListServiceOne.jitter * Double.random(in: -1.0...1.0)

        return next
    }
}

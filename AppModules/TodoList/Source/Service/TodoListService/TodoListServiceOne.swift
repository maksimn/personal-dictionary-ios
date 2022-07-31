//
//  TodoItemCRUDModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 30.06.2021.
//

import CoreModule
import Foundation

private let getTodoList = "GET TODOLIST"
private let createTodoItem = "CREATE TODO ITEM"
private let updateTodoItem = "UPDATE TODO ITEM"
private let deleteTodoItem = "DELETE TODO ITEM"
private let mergeTodoList = "MERGE TODOLIST"

/// Общая логика отправки и обработки сетевых запросов создания, обновления и удаления todo item'a.
class TodoListServiceOne: TodoListService {

    private let isRemotingEnabled: Bool
    private let cache: TodoListCache
    private let deadItemsCache: DeadItemsCache
    private let logger: Logger
    private let networking: NetworkingService
    private let сounter: HttpRequestCounter
    private let mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisher

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    init(isRemotingEnabled: Bool,
         cache: TodoListCache,
         deadItemsCache: DeadItemsCache,
         logger: Logger,
         networking: NetworkingService,
         сounter: HttpRequestCounter,
         mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisher) {
        self.isRemotingEnabled = isRemotingEnabled
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.logger = logger
        self.networking = networking
        self.сounter = сounter
        self.mergeItemsWithRemotePublisher = mergeItemsWithRemotePublisher
    }

    var items: [TodoItem] {
        cache.items
    }

    func fetchRemoteItems(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        if cache.isDirty {
            mergeWithRemote(completion)
        } else {
            logger.networkRequestStart(getTodoList)
            сounter.increment()
            networking.fetchTodoList { [weak self] result in
                self?.сounter.decrement()
                do {
                    self?.logger.networkRequestSuccess(getTodoList)

                    let fetchedTodoList = try result.get().map { $0.map() }
                    let mergedTodoList = self?.items.mergeWith(fetchedTodoList) ?? []
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
        guard isRemotingEnabled else {
            cache.insert(todoItem.update(isDirty: true)) { _ in
                completion(TodoListServiceError.remotingDisabled)
            }

            return
        }

        if cache.isDirty {
            cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }

            return
        }

        logger.networkRequestStart(createTodoItem)
        сounter.increment()
        cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.createTodoItem(TodoItemDTO.map(todoItem)) { [weak self] result in
                self?.сounter.decrement()

                do {
                    _ = try result.get()

                    self?.logger.networkRequestSuccess(createTodoItem)
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
        guard isRemotingEnabled else {
            cache.update(todoItem.update(isDirty: true)) { _ in
                completion(TodoListServiceError.remotingDisabled)
            }

            return
        }

        if cache.isDirty {
            cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }

            return
        }

        logger.networkRequestStart(updateTodoItem)
        сounter.increment()
        cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.updateTodoItem(TodoItemDTO.map(todoItem)) { [weak self] result in
                self?.сounter.decrement()
                do {
                    _ = try result.get()

                    self?.logger.networkRequestSuccess(updateTodoItem)
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
        guard isRemotingEnabled else {
            cache.delete(todoItem) { [weak self] _ in
                let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

                self?.deadItemsCache.insert(tombstone: tombstone) { _ in
                    completion(TodoListServiceError.remotingDisabled)
                }
            }

            return
        }

        cache.delete(todoItem) { [weak self] _ in
            self?.removeRemoteRequest(todoItem, completion)
        }
    }

    func mergeWithRemote(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }.map { TodoItemDTO.map($0) }
        let requestData = MergeTodoListRequestData(deleted: deleted, other: dirtyItems)

        logger.networkRequestStart(mergeTodoList)
        сounter.increment()
        networking.mergeTodoList(requestData) { [weak self] result in
            self?.сounter.decrement()
            do {
                var todoList = try result.get().map({ $0.map() })
                todoList.sortByCreateAt()
                self?.logger.networkRequestSuccess(mergeTodoList)
                self?.deadItemsCache.clearTombstones { _ in

                }
                self?.currentDelay = TodoListServiceOne.minDelay
                self?.cache.replaceWith(todoList) { [weak self] error in
                    self?.mergeItemsWithRemotePublisher.notify()
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
            deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                self?.mergeWithRemote(completion)
            }
        } else {
            logger.networkRequestStart(deleteTodoItem)
            сounter.increment()
            deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                self?.networking.deleteTodoItem(todoItem.id) { [weak self] result in
                    self?.сounter.decrement()
                    do {
                        _ = try result.get()

                        self?.logger.networkRequestSuccess(deleteTodoItem)
                        self?.deadItemsCache.clearTombstones { _ in
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

    enum TodoListServiceError: Error {
        case remotingDisabled
    }
}

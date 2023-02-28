//
//  TodoItemCRUDModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 30.06.2021.
//

import CoreModule
import RxSwift

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
    private let logger: SLogger
    private let networking: NetworkingService
    private let httpRequestCounterPublisher: HttpRequestCounterPublisher
    private let mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisher

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    private let disposeBag = DisposeBag()

    init(isRemotingEnabled: Bool,
         cache: TodoListCache,
         deadItemsCache: DeadItemsCache,
         logger: SLogger,
         networking: NetworkingService,
         httpRequestCounterPublisher: HttpRequestCounterPublisher,
         mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisher) {
        self.isRemotingEnabled = isRemotingEnabled
        self.cache = cache
        self.deadItemsCache = deadItemsCache
        self.logger = logger
        self.networking = networking
        self.httpRequestCounterPublisher = httpRequestCounterPublisher
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
            requestWillStart(getTodoList)
            networking.fetchTodoList()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] fetchedItems in
                        self?.requestDidEnd(getTodoList)

                        let mergedItems = self?.items.mergeWith(fetchedItems) ?? []

                        self?.cache.replaceWith(mergedItems) { error in
                            completion(error)
                        }
                    },
                    onError: { [weak self] error in
                        self?.requestDidEnd(getTodoList, withError: error)
                        completion(error)
                    }
                ).disposed(by: disposeBag)
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

        requestWillStart(createTodoItem)
        cache.insert(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.createTodoItem(todoItem)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] item in
                        self?.requestDidEnd(createTodoItem)
                        self?.cache.update(todoItem.update(isDirty: false)) { _ in
                            completion(nil)
                        }
                    },
                    onError: { [weak self] error in
                        self?.handleItemRequestError(error, todoItem, requestName: createTodoItem, completion)
                    }
                ).disposed(by: self?.disposeBag ?? DisposeBag())
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

        requestWillStart(updateTodoItem)
        cache.update(todoItem.update(isDirty: true)) { [weak self] _ in
            self?.networking.updateTodoItem(todoItem)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] item in
                        self?.requestDidEnd(updateTodoItem)
                        self?.cache.update(todoItem.update(isDirty: false)) { _ in
                            completion(nil)
                        }
                    },
                    onError: { [weak self] error in
                        self?.handleItemRequestError(error, todoItem, requestName: updateTodoItem, completion)
                    }
                ).disposed(by: self?.disposeBag ?? DisposeBag())
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
            let tombstone = Tombstone(itemId: todoItem.id, deletedAt: Date())

            if self?.cache.isDirty ?? false {
                self?.deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                    self?.mergeWithRemote(completion)
                }
            } else {
                self?.requestWillStart(deleteTodoItem)
                self?.deadItemsCache.insert(tombstone: tombstone) { [weak self] _ in
                    self?.networking.deleteTodoItem(todoItem.id)
                        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                        .observeOn(MainScheduler.instance)
                        .subscribe(
                            onSuccess: { [weak self] item in
                                self?.requestDidEnd(deleteTodoItem)
                                self?.deadItemsCache.clearTombstones { _ in
                                    completion(nil)
                                }
                            },
                            onError: { [weak self] error in
                                self?.handleItemRequestError(error, todoItem, requestName: deleteTodoItem, completion)
                            }
                        ).disposed(by: self?.disposeBag ?? DisposeBag())
                }
            }
        }
    }

    func mergeWithRemote(_ completion: @escaping (Error?) -> Void) {
        guard isRemotingEnabled else {
            return completion(TodoListServiceError.remotingDisabled)
        }

        let deleted = Array(Set(deadItemsCache.tombstones.map { $0.itemId }))
        let dirtyItems = cache.items.filter { $0.isDirty }.map { TodoItemDTO($0) }
        let requestData = MergeTodoListRequestData(deleted: deleted, other: dirtyItems)

        requestWillStart(mergeTodoList)
        networking.mergeTodoList(requestData)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] items in
                    self?.requestDidEnd(mergeTodoList)
                    self?.deadItemsCache.clearTombstones { _ in }
                    self?.currentDelay = TodoListServiceOne.minDelay
                    self?.cache.replaceWith(items) { [weak self] error in
                        self?.mergeItemsWithRemotePublisher.notify()
                        completion(error)
                    }
                },
                onError: { [weak self] error in
                    self?.requestDidEnd(deleteTodoItem, withError: error)
                    self?.retryMergeRequestAfterDelay(completion)
                }
            ).disposed(by: disposeBag)
    }

    private func handleItemRequestError(_ error: Error, _ item: TodoItem, requestName: String,
                                        _ completion: @escaping (Error?) -> Void) {
        requestDidEnd(requestName, withError: error)

        if requestName != deleteTodoItem {
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
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            self?.mergeWithRemote(completion)
        }
    }

    private func requestWillStart(_ requestName: String) {
        logger.log("\n\(requestName) NETWORK REQUEST START\n")
        httpRequestCounterPublisher.increment()
    }

    private func requestDidEnd(_ requestName: String, withError error: Error? = nil) {
        httpRequestCounterPublisher.decrement()

        if let error = error {
            logger.log("\n\(requestName) NETWORK REQUEST ERROR\n\("\(error)")\n")
        } else {
            logger.log("\n\(requestName) NETWORK REQUEST SUCCESS\n")
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

//
//  NetworkingServiceMock.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

import RxSwift
@testable import TodoList

class NetworkingServiceMock: NetworkingService {

    var fetchTodoListCallCounter = 0
    var createTodoItemCallCounter = 0
    var updateTodoItemCallCounter = 0
    var deleteTodoItemCallCounter = 0
    var mergeTodoListCallCounter = 0

    func fetchTodoList() -> Single<[TodoItem]> {
        fetchTodoListCallCounter += 1

        return Single.just([])
    }

    func createTodoItem(_ todoItem: TodoItem) -> Single<TodoItem> {
        createTodoItemCallCounter += 1

        return Single.just(TodoItem())
    }

    func updateTodoItem(_ todoItem: TodoItem) -> Single<TodoItem> {
        updateTodoItemCallCounter += 1

        return Single.just(TodoItem())
    }

    func deleteTodoItem(_ id: String) -> Single<TodoItem> {
        deleteTodoItemCallCounter += 1

        return Single.just(TodoItem())
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData) -> Single<[TodoItem]> {
        mergeTodoListCallCounter += 1

        return Single.just([])
    }
}

class MergeItemsWithRemotePublisherMock: MergeItemsWithRemotePublisher {
    func notify() { }
}

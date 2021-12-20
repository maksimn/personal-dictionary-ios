//
//  NetworkingServiceMock.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

class NetworkingServiceMock: NetworkingService {

    var fetchTodoListCallCounter = 0
    var createTodoItemCallCounter = 0
    var updateTodoItemCallCounter = 0
    var deleteTodoItemCallCounter = 0
    var mergeTodoListCallCounter = 0

    func fetchTodoList(_ completion: @escaping (TodoListResult) -> Void) {
        fetchTodoListCallCounter += 1
        completion(.success([]))
    }

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        createTodoItemCallCounter += 1
        completion(.success(todoItemDTO))
    }

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        updateTodoItemCallCounter += 1
        completion(.success(todoItemDTO))
    }

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemResult) -> Void) {
        deleteTodoItemCallCounter += 1
        completion(.success(TodoItemDTO(id: "", text: "", importance: "", done: false, deadline: nil, createdAt: 0,
                                        updatedAt: 0)))
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListResult) -> Void) {
        mergeTodoListCallCounter += 1
        completion(.success([]))
    }
}

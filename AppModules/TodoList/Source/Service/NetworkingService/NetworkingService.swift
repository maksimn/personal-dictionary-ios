//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

typealias TodoListResult = Result<[TodoItemDTO], Error>
typealias TodoItemResult = Result<TodoItemDTO, Error>

protocol NetworkingService {

    func fetchTodoList(_ completion: @escaping (TodoListResult) -> Void)

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void)

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void)

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemResult) -> Void)

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListResult) -> Void)
}

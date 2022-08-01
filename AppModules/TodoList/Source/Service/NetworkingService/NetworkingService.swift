//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import RxSwift

protocol NetworkingService {

    func fetchTodoList() -> Single<[TodoItem]>

    func createTodoItem(_ todoItem: TodoItem) -> Single<TodoItem>
    
    func updateTodoItem(_ todoItem: TodoItem) -> Single<TodoItem>

    func deleteTodoItem(_ id: String) -> Single<TodoItem>

    func mergeTodoList(_ requestData: MergeTodoListRequestData) -> Single<[TodoItem]>
}

//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Combine

protocol TodoListNetworking {

    func fetchTodoList() -> AnyPublisher<[TodoDTO], Error>

    func createTodo(_ todoDTO: TodoDTO) -> AnyPublisher<TodoDTO, Error>

    func updateTodo(_ todoDTO: TodoDTO) -> AnyPublisher<TodoDTO, Error>

    func deleteTodo(_ id: String) -> AnyPublisher<TodoDTO, Error>

    func syncTodoList(_ requestData: SyncTodoListRequestData) -> AnyPublisher<[TodoDTO], Error>
}

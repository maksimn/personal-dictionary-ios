//
//  TodoListNetworking.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

protocol TodoListNetworking {

    func fetchTodoList() async throws -> [TodoDTO]

    func createTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO

    func updateTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO

    func deleteTodo(_ id: String) async throws -> TodoDTO

    func syncTodoList(_ requestData: SyncTodoListRequestData) async throws -> [TodoDTO]
}

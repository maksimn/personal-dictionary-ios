//
//  TodoListService.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import CoreModule

protocol TodoListService {

    func getTodos() async throws -> [Todo]

    func createRemote(_ todo: Todo) async throws

    func updateRemote(_ todo: Todo) async throws

    func deleteRemote(_ todo: Todo) async throws
}

struct TodoListServiceImp: TodoListService {

    private let urlString: String
    private let headers: [String: String]
    private let httpClient: HttpClientAdapter

    init(urlString: String,
         headers: [String: String],
         httpClient: HttpClientAdapter) {
        self.urlString = urlString
        self.headers = headers
        self.httpClient = httpClient
    }

    func getTodos() async throws -> [Todo] {
        try await fetchTodoList().mapAndSort()
    }

    func createRemote(_ todo: Todo) async throws {
        _ = try await createTodo(TodoDTO(todo))
    }

    func updateRemote(_ todo: Todo) async throws {
        _ = try await updateTodo(TodoDTO(todo))
    }

    func deleteRemote(_ todo: Todo) async throws {
        _ = try await deleteTodo(todo.id)
    }

    private func fetchTodoList() async throws -> [TodoDTO] {
        try await httpClient.sendAndDecode(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            )
        )
    }

    private func createTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO {
        try await httpClient.sendAndDecode(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            todoDTO
        )
    }

    private func updateTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO {
        try await httpClient.sendAndDecode(
            Http(
                urlString: "\(urlString)/tasks/\(todoDTO.id)",
                method: "PUT",
                headers: headers
            ),
            todoDTO
        )
    }

    private func deleteTodo(_ id: String) async throws -> TodoDTO {
        try await httpClient.sendAndDecode(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            )
        )
    }
}

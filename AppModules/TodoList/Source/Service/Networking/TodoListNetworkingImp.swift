//
//  TodoListNetworkingImp.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import CoreModule
import Foundation

struct TodoListNetworkingImp: TodoListNetworking {

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

    func fetchTodoList() async throws -> [TodoDTO] {
        try await send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            )
        )
    }

    func createTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO {
        try await send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            todoDTO
        )
    }

    func updateTodo(_ todoDTO: TodoDTO) async throws -> TodoDTO {
        try await send(
            Http(
                urlString: "\(urlString)/tasks/\(todoDTO.id)",
                method: "PUT",
                headers: headers
            ),
            todoDTO
        )
    }

    func deleteTodo(_ id: String) async throws -> TodoDTO {
        try await send(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            )
        )
    }

    func syncTodoList(_ requestData: SyncTodoListRequestData) async throws -> [TodoDTO] {
        try await send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            requestData
        )
    }

    private func send<OutputDTO: Decodable>(_ http: Http) async throws -> OutputDTO {
        let httpResponse = try await httpClient.send(http)

        return try JSONDecoder().decode(OutputDTO.self, from: httpResponse.data)
    }

    private func send<InputDTO: Encodable, OutputDTO: Decodable>(_ http: Http,
                                                                 _ dto: InputDTO) async throws -> OutputDTO {
        let body = try JSONEncoder().encode(dto)
        let httpResponse = try await httpClient.send(
            Http(
                urlString: http.urlString,
                method: http.method,
                headers: http.headers,
                body: body
            )
        )

        return try JSONDecoder().decode(OutputDTO.self, from: httpResponse.data)
    }
}

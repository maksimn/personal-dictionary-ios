//
//  TodoListNetworkingImp.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Combine
import CoreModule
import Foundation

class TodoListNetworkingImp: TodoListNetworking {

    private let urlString: String
    private let headers: [String: String]
    private let httpClient: HttpClient

    init(urlString: String,
         headers: [String: String],
         httpClient: HttpClient) {
        self.urlString = urlString
        self.headers = headers
        self.httpClient = httpClient
    }

    func fetchTodoList() -> AnyPublisher<[TodoDTO], Error> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            )
        )
    }

    func createTodo(_ todoDTO: TodoDTO) -> AnyPublisher<TodoDTO, Error> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            todoDTO
        )
    }

    func updateTodo(_ todoDTO: TodoDTO) -> AnyPublisher<TodoDTO, Error> {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(todoDTO.id)",
                method: "PUT",
                headers: headers
            ),
            todoDTO
        )
    }

    func deleteTodo(_ id: String) -> AnyPublisher<TodoDTO, Error> {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            )
        )
    }

    func syncTodoList(_ requestData: SyncTodoListRequestData) -> AnyPublisher<[TodoDTO], Error> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            requestData
        )
    }

    private func send<OutputDTO: Decodable>(_ http: Http) -> AnyPublisher<OutputDTO, Error> {
        httpClient.send(http)
            .tryMap { httpResponse in
                httpResponse.data
            }
            .decode(type: OutputDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func send<InputDTO: Encodable, OutputDTO: Decodable>(_ http: Http,
                                                                 _ dto: InputDTO) -> AnyPublisher<OutputDTO, Error> {
        Just(dto)
            .encode(encoder: JSONEncoder())
            .flatMap { data in
                self.send(
                    Http(
                        urlString: http.urlString,
                        method: http.method,
                        headers: http.headers,
                        body: data
                    )
                )
            }
            .eraseToAnyPublisher()
    }
}

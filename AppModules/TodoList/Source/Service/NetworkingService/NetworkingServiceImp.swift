//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import CoreModule
import Foundation
import RxSwift

class NetworkingServiceImp: NetworkingService {

    private let urlString: String
    private let headers: [String: String]
    private let httpClient: HttpClient
    private let todoCoder: JsonCoder

    private let disposeBag = DisposeBag()

    init(urlString: String,
         headers: [String: String],
         httpClient: HttpClient,
         todoCoder: JsonCoder) {
        self.urlString = urlString
        self.headers = headers
        self.httpClient = httpClient
        self.todoCoder = todoCoder
    }

    func fetchTodoList() -> Single<[TodoItem]> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            )
        ).map { (dtoItems: [TodoItemDTO]) in
            dtoItems.map { $0.map() }
        }
    }

    func createTodoItem(_ todoItem: TodoItem) -> Single<TodoItem> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            dto: TodoItemDTO.map(todoItem)
        ).map { (dto: TodoItemDTO) in
            dto.map()
        }
    }

    func updateTodoItem(_ todoItem: TodoItem) -> Single<TodoItem> {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(todoItem.id)",
                method: "PUT",
                headers: headers
            ),
            dto: TodoItemDTO.map(todoItem)
        ).map { (dto: TodoItemDTO) in
            dto.map()
        }
    }

    func deleteTodoItem(_ id: String) -> Single<TodoItem> {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            )
        ).map { (dto: TodoItemDTO) in
            dto.map()
        }
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData) -> Single<[TodoItem]> {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            dto: requestData
        ).map { (dtoItems: [TodoItemDTO]) in
            dtoItems.map { $0.map() }
        }
    }

    private func send<OutputDTO: DTO>(_ http: Http) -> Single<OutputDTO> {
        httpClient.send(http)
            .map { [weak self] data -> Single<OutputDTO> in
                self?.todoCoder.parseFromJson(data) ?? .error(DefaultNetworkingService.error)
            }
            .asObservable().concat().asSingle()
    }

    private func send<InputDTO: Encodable, OutputDTO: DTO>(_ http: Http, dto: InputDTO) -> Single<OutputDTO> {
        todoCoder.convertToJson(dto)
            .map { [weak self] data -> Single<Data> in
                self?.httpClient.send(
                    Http(
                        urlString: http.urlString,
                        method: http.method,
                        headers: http.headers,
                        body: data
                    )
                ) ?? .error(DefaultNetworkingService.error)
            }
            .asObservable().concat().asSingle()
            .map { [weak self] data -> Single<OutputDTO> in
                self?.todoCoder.parseFromJson(data) ?? .error(DefaultNetworkingService.error)
            }
            .asObservable().concat().asSingle()
    }

    enum DefaultNetworkingService: Error {
        case error
    }
}

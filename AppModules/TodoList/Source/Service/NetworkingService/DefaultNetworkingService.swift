//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import CoreModule
import Foundation
import RxSwift

class DefaultNetworkingService: NetworkingService {

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

    func fetchTodoList(_ completion: @escaping (TodoListResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "GET",
                headers: headers
            ),
            completion
        )
    }

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "POST",
                headers: headers
            ),
            todoItemDTO,
            completion
        )
    }

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(todoItemDTO.id)",
                method: "PUT",
                headers: headers
            ),
            todoItemDTO,
            completion
        )
    }

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/\(id)",
                method: "DELETE",
                headers: headers
            ),
            completion
        )
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListResult) -> Void) {
        send(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            requestData,
            completion
        )
    }

    private func send<T: Decodable>(_ http: Http, _ completion: @escaping (Result<T, Error>) -> Void) {
        httpClient.send(http)
            .map { [weak self] data -> Single<T> in
                self?.todoCoder.parseFromJson(data) ?? .error(DefaultNetworkingService.error)
            }
            .asObservable().concat().asSingle()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess:  { result in
                    completion(.success(result))
                },
                onError: { error in
                    completion(.failure(error))
                }
            ).disposed(by: disposeBag)
    }

    private func send<T: Decodable, Body: Encodable>(_ http: Http, _ body: Body,
        _ completion: @escaping (Result<T, Error>) -> Void) {
        todoCoder.convertToJson(body)
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
            .map { [weak self] data -> Single<T> in
                self?.todoCoder.parseFromJson(data) ?? .error(DefaultNetworkingService.error)
            }
            .asObservable().concat().asSingle()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess:  { result in
                    completion(.success(result))
                },
                onError: { error in
                    completion(.failure(error))
                }
            ).disposed(by: disposeBag)
    }

    enum DefaultNetworkingService: Error {
        case error
    }
}

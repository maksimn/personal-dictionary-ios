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

    private let coreService: CoreService
    private let todoCoder: JsonCoder
    private let jsonHeaders = [BearerToken.key: BearerToken.value, "Content-Type": "application/json"]

    private let disposeBag = DisposeBag()

    init(_ coreService: CoreService, _ todoCoder: JsonCoder) {
        self.coreService = coreService
        self.todoCoder = todoCoder
    }

    func fetchTodoList(_ completion: @escaping (TodoListResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/",
                        httpMethod: "GET",
                        headers: [BearerToken.key: BearerToken.value])
        coreService.send(nil) { [weak self] result in
            self?.todoListRequestHandler(result, completion)
        }
    }

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/",
                        httpMethod: "POST",
                        headers: jsonHeaders)
        todoCoder.convertToJson(todoItemDTO)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.coreService.send(data) { [weak self] result in
                        self?.todoItemRequestHandler(result, completion)
                    }
                },
                onError: { error in
                    completion(.failure(error))
                }
            )
            .disposed(by: disposeBag)
    }

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/\(todoItemDTO.id)",
                        httpMethod: "PUT",
                        headers: jsonHeaders)
        todoCoder.convertToJson(todoItemDTO)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.coreService.send(data) { [weak self] result in
                        self?.todoItemRequestHandler(result, completion)
                    }
                },
                onError: { error in
                    completion(.failure(error))
                }
            )
            .disposed(by: disposeBag)
    }

    func deleteTodoItem(_ id: String, _ completion: @escaping (TodoItemResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/\(id)",
                        httpMethod: "DELETE",
                        headers: [BearerToken.key: BearerToken.value])
        coreService.send(nil) { [weak self] result in
            self?.todoItemRequestHandler(result, completion)
        }
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/",
                        httpMethod: "PUT",
                        headers: jsonHeaders)
        todoCoder.convertToJson(requestData)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.coreService.send(data) { [weak self] result in
                        self?.todoListRequestHandler(result, completion)
                    }
                },
                onError: { error in
                    completion(.failure(error))
                }
            )
            .disposed(by: disposeBag)
    }

    private func todoListRequestHandler(_ result: Result<Data, Error>,
                                        _ completion: @escaping (Result<[TodoItemDTO], Error>) -> Void) {
        do {
            let data = try result.get()

            todoCoder.parseFromJson(data)
                .subscribe(
                    onSuccess: { (array: [TodoItemDTO]) in
                        completion(.success(array))
                    },
                    onError: { error in
                        completion(.failure(error))
                    }
                )
                .disposed(by: disposeBag)
        } catch {
            completion(.failure(error))
        }
    }

    private func todoItemRequestHandler(_ result: Result<Data, Error>,
                                        _ completion: @escaping (Result<TodoItemDTO, Error>) -> Void) {
        do {
            let data = try result.get()

            todoCoder.parseFromJson(data)
                .subscribe(
                    onSuccess: { (todoItemDTO: TodoItemDTO) in
                        completion(.success(todoItemDTO))
                    },
                    onError: { error in
                        completion(.failure(error))
                    }
                )
                .disposed(by: disposeBag)
        } catch {
            completion(.failure(error))
        }
    }
}

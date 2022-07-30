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
    private let coreService: CoreService
    private let todoCoder: JsonCoder

    private let disposeBag = DisposeBag()

    init(urlString: String,
         headers: [String: String],
         coreService: CoreService,
         todoCoder: JsonCoder) {
        self.urlString = urlString
        self.headers = headers
        self.coreService = coreService
        self.todoCoder = todoCoder
    }

    func fetchTodoList(_ completion: @escaping (TodoListResult) -> Void) {
        coreService.set(urlString: "\(urlString)/tasks/",
                        httpMethod: "GET",
                        headers: headers)
        coreService.send(nil) { [weak self] result in
            self?.todoListRequestHandler(result, completion)
        }
    }

    func createTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        coreService.set(urlString: "\(urlString)/tasks/",
                        httpMethod: "POST",
                        headers: headers)
        todoCoder.convertToJson(todoItemDTO)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
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
        coreService.set(urlString: "\(urlString)/tasks/\(todoItemDTO.id)",
                        httpMethod: "PUT",
                        headers: headers)
        todoCoder.convertToJson(todoItemDTO)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
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
        coreService.set(urlString: "\(urlString)/tasks/\(id)",
                        httpMethod: "DELETE",
                        headers: headers)
        coreService.send(nil) { [weak self] result in
            self?.todoItemRequestHandler(result, completion)
        }
    }

    func mergeTodoList(_ requestData: MergeTodoListRequestData, _ completion: @escaping (TodoListResult) -> Void) {
        coreService.set(urlString: "\(urlString)/tasks/",
                        httpMethod: "PUT",
                        headers: headers)
        todoCoder.convertToJson(requestData)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
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
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
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
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .observeOn(MainScheduler.instance)
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

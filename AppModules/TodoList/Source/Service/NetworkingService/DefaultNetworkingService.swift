//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

class DefaultNetworkingService: NetworkingService {

    private let coreService: CoreService
    private let todoCoder: TodoCoder
    private let jsonHeaders = [BearerToken.key: BearerToken.value, "Content-Type": "application/json"]

    init(_ coreService: CoreService, _ todoCoder: TodoCoder) {
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
        todoCoder.encodeAsync(todoItemDTO) { [weak self] result in
            do {
                let data = try result.get()

                self?.coreService.send(data) { [weak self] result in
                    self?.todoItemRequestHandler(result, completion)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateTodoItem(_ todoItemDTO: TodoItemDTO, _ completion: @escaping (TodoItemResult) -> Void) {
        coreService.set(urlString: "\(WebAPI.baseUrl)/tasks/\(todoItemDTO.id)",
                        httpMethod: "PUT",
                        headers: jsonHeaders)
        todoCoder.encodeAsync(todoItemDTO) { [weak self] result in
            switch result {
            case .success(let data):
                self?.coreService.send(data) { [weak self] result in
                    self?.todoItemRequestHandler(result, completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
        todoCoder.encodeAsync(requestData) { [weak self] result in
            switch result {
            case .success(let data):
                self?.coreService.send(data) { [weak self] result in
                    self?.todoListRequestHandler(result, completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func todoListRequestHandler(_ result: Result<Data, Error>,
                                        _ completion: @escaping (Result<[TodoItemDTO], Error>) -> Void) {
        do {
            let data = try result.get()

            todoCoder.decodeAsync(data) { (result: Result<[TodoItemDTO], Error>) in
                switch result {
                case .success(let array):
                    completion(.success(array))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func todoItemRequestHandler(_ result: Result<Data, Error>,
                                        _ completion: @escaping (Result<TodoItemDTO, Error>) -> Void) {
        do {
            let data = try result.get()

            todoCoder.decodeAsync(data) { (result: Result<TodoItemDTO, Error>) in
                switch result {
                case .success(let todoItemDTO):
                    completion(.success(todoItemDTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

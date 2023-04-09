//
//  TodoListServiceImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import Combine
import Foundation

final class TodoListServiceImp: TodoListService {

    private let networking: TodoListNetworking

    private static let minDelay: Double = 2
    private static let maxDelay: Double = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    private var currentDelay: Double = 2

    private var syncAttempts = 0
    private let maxSyncAttempts = 6
    private var hasPendingSyncRequest = false

    private var cancellables: Set<AnyCancellable> = []

    init(networking: TodoListNetworking) {
        self.networking = networking
    }

    func getTodos() async throws -> [Todo] {
        return try await withCheckedThrowingContinuation { continuation in
            networking.fetchTodoList()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                }, receiveValue: { dtos in
                    continuation.resume(returning: dtos.mapAndSort())
                })
                .store(in: &self.cancellables)
        }
    }

    func createRemote(_ todo: Todo) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            networking.createTodo(TodoDTO(todo))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                }, receiveValue: { dto in
                    continuation.resume(returning: Void())
                })
                .store(in: &self.cancellables)
        }
    }

    func updateRemote(_ todo: Todo) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            networking.updateTodo(TodoDTO(todo))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                }, receiveValue: { dto in
                    continuation.resume(returning: Void())
                })
                .store(in: &self.cancellables)
        }
    }

    func deleteRemote(_ todo: Todo) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            networking.deleteTodo(todo.id)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                }, receiveValue: { dto in
                    continuation.resume(returning: Void())
                })
                .store(in: &self.cancellables)
        }
    }

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo] {
        return try await withCheckedThrowingContinuation { continuation in
            syncWithRemote(deleted, other) { result in
                continuation.resume(with: result)
            }
        }
    }

    private func syncWithRemote(_ deleted: [String], _ other: [Todo], _ completion: @escaping TodoListCallback) {
        if hasPendingSyncRequest {
            return completion(.failure(TodoListServiceError.syncRequestPending))
        }

        hasPendingSyncRequest = true

        let requestData = SyncTodoListRequestData(deleted: deleted, other: other.map { TodoDTO($0) })

        networking.syncTodoList(requestData)
            .sink(receiveCompletion: { completionValue in
                switch completionValue {
                case .failure(let error):
                    if self.syncAttempts > self.maxSyncAttempts {
                        self.syncAttempts = 0
                        self.hasPendingSyncRequest = false

                        return completion(.failure(error))
                    }

                    self.retrySyncRequestAfter(
                        delay: self.nextDelay, deleted, other, completion
                    )
                    self.currentDelay = self.nextDelay

                case .finished:
                    break
                }
            }, receiveValue: { dtos in
                self.currentDelay = TodoListServiceImp.minDelay
                self.syncAttempts = 0
                self.hasPendingSyncRequest = false

                completion(.success(dtos.mapAndSort()))
            })
            .store(in: &self.cancellables)
    }

    private var nextDelay: Double {
        let delay = min(currentDelay * TodoListServiceImp.factor, TodoListServiceImp.maxDelay)
        let next = delay + delay * TodoListServiceImp.jitter * Double.random(in: -1.0...1.0)

        return next
    }

    private func retrySyncRequestAfter(delay: Double, _ deleted: [String], _ other: [Todo],
                                       _ completion: @escaping TodoListCallback) {
        syncAttempts += 1
        let seconds: Int = Int(delay)
        let milliseconds: Int = Int((delay - Double(seconds)) * Double(1000))
        let deadlineTime = DispatchTime.now() + .seconds(seconds) + .milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            self?.syncWithRemote(deleted, other, completion)
        }
    }

    enum TodoListServiceError: Error {
        case syncRequestPending
    }
}

//
//  TodoListServiceImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

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

    init(networking: TodoListNetworking) {
        self.networking = networking
    }

    func getTodos() async throws -> [Todo] {
        return try await withCheckedThrowingContinuation { continuation in
            networking.fetchTodoList { result in
                switch result {
                case .success(let dtos):
                    continuation.resume(returning: TodoListServiceImp.mapAndSort(dtos))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func createRemote(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            createRemote(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func updateRemote(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            updateRemote(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func deleteRemote(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteRemote(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo] {
        return try await withCheckedThrowingContinuation { continuation in
            syncWithRemote(deleted, other) { result in
                continuation.resume(with: result)
            }
        }
    }

    private func createRemote(_ todo: Todo, _ completion: @escaping VoidCallback) {
        networking.createTodo(TodoDTO(todo)) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(TodoListServiceError.createFailed(error)))
            }
        }
    }

    private func updateRemote(_ todo: Todo, _ completion: @escaping VoidCallback) {
        networking.updateTodo(TodoDTO(todo)) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(TodoListServiceError.updateFailed(error)))
            }
        }
    }

    private func deleteRemote(_ todo: Todo, _ completion: @escaping VoidCallback) {
        networking.deleteTodo(todo.id) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(TodoListServiceError.deleteFailed(error)))
            }
        }
    }

    private func syncWithRemote(_ deleted: [String], _ other: [Todo], _ completion: @escaping TodoListCallback) {
        if hasPendingSyncRequest {
            return completion(.failure(TodoListServiceError.syncRequestPending))
        }

        hasPendingSyncRequest = true

        let requestData = SyncTodoListRequestData(deleted: deleted, other: other.map { TodoDTO($0) })
        networking.syncTodoList(requestData) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let dtos):
                self.currentDelay = TodoListServiceImp.minDelay
                self.syncAttempts = 0
                self.hasPendingSyncRequest = false

                completion(.success(TodoListServiceImp.mapAndSort(dtos)))
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
            }
        }
    }

    private static func mapAndSort(_ dtos: [TodoDTO]) -> [Todo] {
        var todos = dtos.map { Todo($0) }

        todos.sortByCreateAt()

        return todos
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
}

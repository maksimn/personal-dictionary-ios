//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol TodoListCache {

    var todos: [Todo] { get throws }

    func insert(_ todo: Todo) async throws

    func update(_ todo: Todo) async throws

    func delete(_ todo: Todo) async throws

    func replaceWith(_ todoList: [Todo]) async throws
}

struct TodoListCacheImp: TodoListCache {

    private let cbTodoListCache: CBTodoListCache

    init(cbTodoListCache: CBTodoListCache) {
        self.cbTodoListCache = cbTodoListCache
    }

    var todos: [Todo] {
        get throws {
            do {
                return try cbTodoListCache.todos
            } catch {
                throw TodoListCacheError.getTodosError(error)
            }
        }
    }

    func insert(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbTodoListCache.insert(todo) { result in
                callback(continuation, withResult: result, withError: TodoListCacheError.insertError)
            }
        }
    }

    func update(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbTodoListCache.update(todo) { result in
                callback(continuation, withResult: result, withError: TodoListCacheError.updateError)
            }
        }
    }

    func delete(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbTodoListCache.delete(todo) { result in
                callback(continuation, withResult: result, withError: TodoListCacheError.deleteError)
            }
        }
    }

    func replaceWith(_ todoList: [Todo]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbTodoListCache.replaceWith(todoList) { result in
                callback(continuation, withResult: result, withError: TodoListCacheError.replaceWithError)
            }
        }
    }

    private func callback(_ continuation: CheckedContinuation<Void, any Error>,
                          withResult result: Result<Void, any Error>, withError: (Error) -> Error) {
        switch result {
        case .success:
            continuation.resume()
        case .failure(let error):
            continuation.resume(throwing: withError(error))
        }
    }
}

enum TodoListCacheError: Error {
    case getTodosError(Error)
    case insertError(Error)
    case updateError(Error)
    case deleteError(Error)
    case replaceWithError(Error)
}

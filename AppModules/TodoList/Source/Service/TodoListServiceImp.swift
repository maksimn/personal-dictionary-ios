//
//  TodoListServiceImp.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

struct TodoListServiceImp: TodoListService {

    private let networking: TodoListNetworking

    init(networking: TodoListNetworking) {
        self.networking = networking
    }

    func getTodos() async throws -> [Todo] {
        try await networking
            .fetchTodoList()
            .mapAndSort()
    }

    func createRemote(_ todo: Todo) async throws {
        _ = try await networking.createTodo(TodoDTO(todo))
    }

    func updateRemote(_ todo: Todo) async throws {
        _ = try await networking.updateTodo(TodoDTO(todo))
    }

    func deleteRemote(_ todo: Todo) async throws {
        _ = try await networking.deleteTodo(todo.id)
    }

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo] {
        let requestData = SyncTodoListRequestData(deleted: deleted, other: other.map { TodoDTO($0) })

        return try await networking
            .syncTodoList(requestData)
            .mapAndSort()
    }
}

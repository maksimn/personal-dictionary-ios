//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol TodoListCache {

    var todos: [Todo] { get throws }

    var dirtyTodos: [Todo] { get throws }

    var isDirty: Bool { get }

    func insert(_ todo: Todo) async throws

    func update(_ todo: Todo) async throws

    func delete(_ todo: Todo) async throws

    func replaceWith(_ todoList: [Todo]) async throws
}

enum TodoListCacheError: Error {
    case getTodosError(Error)
    case getDirtyTodosError(Error)
    case insertError(Error)
    case updateError(Error)
    case deleteError(Error)
    case replaceWithError(Error)
}

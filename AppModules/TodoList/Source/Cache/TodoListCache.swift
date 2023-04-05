//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol TodoListCache {

    var isDirty: Bool { get }

    var todos: [Todo] { get }

    func insert(_ todo: Todo) async throws

    func update(_ todo: Todo) async throws

    func delete(_ todo: Todo) async throws

    func replaceWith(_ todoList: [Todo]) async throws
}

enum TodoListCacheError: Error {
    case insertFailed(Error)
    case updateFailed(Error)
    case deleteFailed(Error)
}

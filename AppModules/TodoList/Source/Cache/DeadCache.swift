//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol DeadCache {

    var isEmpty: Bool { get }

    var items: [Tombstone] { get throws }

    func insert(_ item: Tombstone) async throws

    func clear() async throws
}

enum DeadCacheError: Error {
    case getItemsError(Error)
    case insertError(Error)
    case clearError(Error)
}

//
//  Mocks.swift
//  TodoList
//
//  Created by Maksim Ivanov on 18.07.2023.
//

@testable import TodoList

enum ErrorMock: Error {
    case error
}

class DirtyStateCacheMock: DirtyStateCache {

    var dirtyDataMock: (() -> DirtyData)?

    var dirtyData: DirtyData {
        dirtyDataMock!()
    }
}

class SyncServiceMock: SyncService {

    var syncWithRemoteTodosMock: ((DirtyData) throws -> [Todo])?

    func syncWithRemoteTodos(_ dirtyData: DirtyData) async throws -> [Todo] {
        try syncWithRemoteTodosMock!(dirtyData)
    }
}

class TodoListCacheMock: TodoListCache {

    var todosMock: (() -> [Todo])?
    var insertMock: ((Todo) throws -> Void)?
    var updateMock: ((Todo) throws -> Void)?
    var deleteMock: ((Todo) throws -> Void)?
    var replaceWithMock: (([Todo]) throws -> Void)?

    var todos: [Todo] {
        todosMock!()
    }

    func insert(_ todo: Todo) async throws {
        try insertMock!(todo)
    }

    func update(_ todo: Todo) async throws {
        try updateMock!(todo)
    }

    func delete(_ todo: Todo) async throws {
        try deleteMock!(todo)
    }

    func replaceWith(_ todoList: [Todo]) async throws {
        try replaceWithMock!(todoList)
    }
}

class TodoListServiceMock: TodoListService {

    var getTodosMock: (() throws -> [Todo])?
    var createRemoteMock: ((Todo) throws -> Void)?
    var updateRemoteMock: ((Todo) throws -> Void)?
    var deleteRemoteMock: ((Todo) throws -> Void)?

    func getTodos() async throws -> [Todo] {
        try getTodosMock!()
    }

    func createRemote(_ todo: Todo) async throws {
        try createRemoteMock!(todo)
    }

    func updateRemote(_ todo: Todo) async throws {
        try updateRemoteMock!(todo)
    }

    func deleteRemote(_ todo: Todo) async throws {
        try deleteRemoteMock!(todo)
    }
}

class TombstonesMock: TombstoneInsertable, Clearable {

    var insertMock: ((Tombstone) throws -> Void)?
    var clearMock: (() throws -> Void)?

    func insert(_ item: Tombstone) async throws {
        try insertMock!(item)
    }

    func clear() async throws {
        try clearMock!()
    }
}

class DirtyStateStatusMock: DirtyStateStatus {

    var isDirtyMock: (() -> Bool)?

    var isDirty: Bool {
        isDirtyMock!()
    }
}

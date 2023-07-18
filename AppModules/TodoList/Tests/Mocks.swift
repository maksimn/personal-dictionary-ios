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

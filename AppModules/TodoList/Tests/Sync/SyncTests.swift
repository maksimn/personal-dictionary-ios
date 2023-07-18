//
//  SyncTests.swift
//  TodoList
//
//  Created by Maksim Ivanov on 18.07.2023.
//

import ComposableArchitecture
import XCTest
@testable import TodoList

private let syncParams = SyncParams(minDelay: 2.0, maxDelay: 120, factor: 1.5, jitter: 0.05)

@MainActor
class SyncTests: XCTestCase {

    var store: TestStoreOf<Sync>!
    var dirtyStateCacheMock: DirtyStateCacheMock!
    var syncServiceMock: SyncServiceMock!

    func test_setDelayToMinValue_delayIsGreaterThanMinValue_resultingDelayIsEqualToMinValue() async {
        arrange()

        await store.send(.setDelayToMinValue) {
            $0.delay = syncParams.minDelay
        }
    }

    func test_nextDelay_currentDelayIsMeduim_resultingDelayIsAboutCurrentValueMultipliedByFactor() async {
        arrange()

        await store.send(.nextDelay) {
            $0.delay = 46.125 - 1.0e-14
        }
    }

    func test_nextDelay_currentDelayIsMax_resultingDelayIsAboutMaxValue() async {
        arrange(currentDelay: syncParams.maxDelay)

        await store.send(.nextDelay) {
            $0.delay = 123.0 - 1.0e-14
        }
    }

    // Sync scenario
    // Server: [A, B]
    // Client: [A, B, C(dirty)]
    // Sync result: success.
    func test_syncWithRemoteTodos_dirtyTodoCreated_todoListSyncedSuccessfully() async {
        // Arrange:
        arrange()

        store.exhaustivity = .off

        let dirtyTodo = Todo(text: "C", isDirty: true)
        let dirtyData = DirtyData(dirtyTodos: [dirtyTodo], tombstones: [])
        let resultTodos = [Todo(text: "A"), Todo(text: "B"), dirtyTodo.update(isDirty: false)]

        dirtyStateCacheMock.dirtyDataMock = { dirtyData }
        syncServiceMock.syncWithRemoteTodosMock = {
            if $0 == dirtyData {
                return resultTodos
            } else {
                throw ErrorMock.error
            }
        }

        // Act:
        await store.send(.syncWithRemoteTodos)

        // Assert:
        await store.receive(.syncWithRemoteTodosResult(.success(resultTodos)))
        await store.receive(.setDelayToMinValue)
    }

    // Sync scenario
    // Server: [A, B]
    // Client: [A, B, C(dirty)]
    // Sync result: error.
    func test_syncWithRemoteTodos_dirtyTodoCreated_syncServiceThrowsError() async {
        // Arrange:
        arrange(currentDelay: 0)

        let dirtyTodo = Todo(text: "C", isDirty: true)
        let dirtyData = DirtyData(dirtyTodos: [dirtyTodo], tombstones: [])

        dirtyStateCacheMock.dirtyDataMock = { dirtyData }
        syncServiceMock.syncWithRemoteTodosMock = { _ in throw ErrorMock.error }

        // Act:
        await store.send(.syncWithRemoteTodos)

        // Assert:
        await store.receive(.syncWithRemoteTodosResult(.failure(ErrorMock.error)))
    }

    // Sync scenario
    // Server: [A, B]
    // Client: [A, B, C(dirty)], changed to [A, B, C(dirty), D(dirty)] during sync request.
    // Sync result: error.
    func test_syncWithRemoteTodos_dirtyStateChangedDuringRequest_receivingSyncError() async {
        // Arrange:
        arrange(currentDelay: 0)

        let dirtyTodo = Todo(text: "C", isDirty: true)
        let dirtyData = DirtyData(dirtyTodos: [dirtyTodo], tombstones: [])
        let resultTodos = [Todo(text: "A"), Todo(text: "B"), dirtyTodo.update(isDirty: false)]
        let dirtyDataAfter = DirtyData(dirtyTodos: [dirtyTodo, Todo(text: "D", isDirty: true)], tombstones: [])
        var i = 0

        dirtyStateCacheMock.dirtyDataMock = {
            i += 1
            return i == 1 ? dirtyData : dirtyDataAfter
        }
        syncServiceMock.syncWithRemoteTodosMock = { _ in resultTodos }

        // Act:
        await store.send(.syncWithRemoteTodos)

        // Assert:
        await store.receive(.syncWithRemoteTodosResult(.failure(SyncError.dirtyStateChangedDuringRequest)))
    }

    private func arrange(
        syncParams: SyncParams = syncParams,
        currentDelay: Double = 30.0,
        randomDouble: Double = 0.5
    ) {
        dirtyStateCacheMock = DirtyStateCacheMock()
        syncServiceMock = SyncServiceMock()
        store = TestStore(initialState: Sync.State(delay: currentDelay)) {
            Sync(
                params: syncParams,
                dirtyStateCache: dirtyStateCacheMock,
                syncService: syncServiceMock,
                randomNumber: { randomDouble }
            )
        }
    }
}

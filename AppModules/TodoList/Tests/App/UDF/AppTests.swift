//
//  AppTests.swift
//  TodoList
//
//  Created by Maksim Ivanov on 23.07.2023.
//

import ComposableArchitecture
import XCTest
@testable import TodoList

@MainActor
class AppTests: XCTestCase {

    var store: TestStoreOf<App>!
    var cacheMock: TodoListCacheMock!
    var serviceMock: TodoListServiceMock!
    var dirtyStateStatusMock: DirtyStateStatusMock!
    var tombstonesMock: TombstonesMock!

    var todos: [Todo]!

    func arrange(isDirty: Bool = false, networkIndicatorState: NetworkIndicator.State = .init()) {
        cacheMock = TodoListCacheMock()
        dirtyStateStatusMock = DirtyStateStatusMock()
        serviceMock = TodoListServiceMock()
        tombstonesMock = TombstonesMock()
        store = TestStore(
            initialState: App.State(networkIndicator: networkIndicatorState, sync: .init(delay: 0))
        ) {
            App(
                syncConfig: SyncConfig(token: "", minDelay: 0),
                cache: cacheMock,
                service: serviceMock,
                tombstones: tombstonesMock,
                dirtyStateStatus: dirtyStateStatusMock,
                currentDate: { Date(timeIntervalSince1970: 0) }
            )
        }

        store.exhaustivity = .off

        let todos = [Todo(text: "A"), Todo(text: "B")]

        cacheMock.todosMock = { todos }
        cacheMock.insertMock = { _ in }
        cacheMock.updateMock = { _ in }
        cacheMock.deleteMock = { _ in }
        cacheMock.replaceWithMock = { _ in }
        dirtyStateStatusMock.isDirtyMock = { isDirty }
        serviceMock.getTodosMock = { todos }
        serviceMock.createRemoteMock = { _ in }
        serviceMock.updateRemoteMock = { _ in }
        serviceMock.deleteRemoteMock = { _ in }
        tombstonesMock.insertMock = { _ in }
        tombstonesMock.clearMock = { }
        self.todos = todos
    }

    func test_start_cachedDataIsClean_retrievesTodosFromCache() async {
        // Arrange
        arrange()

        // Act
        await store.send(.start)

        // Assert
        await store.receive(.mainList(.updateTodos(todos)))
    }

    func test_start_cachedDataIsClean_initiatesGetTodosServerRequest() async {
        // Arrange
        arrange()

        // Act
        await store.send(.start)

        // Assert
        await store.receive(.getRemoteTodos)
    }

    func test_start_cachedDataIsDirty_retrievesTodosFromCache() async {
        // Arrange
        arrange()
        dirtyStateStatusMock.isDirtyMock = { true }

        // Act
        await store.send(.start)

        // Assert
        await store.receive(.mainList(.updateTodos(todos)))
    }

    func test_start_cachedDataIsDirty_initiatesSyncRequest() async {
        // Arrange
        arrange()
        dirtyStateStatusMock.isDirtyMock = { true }

        // Act
        await store.send(.start)

        // Assert
        await store.receive(.sync(.syncWithRemoteTodos))
    }

    func test_getRemoteTodos_requestsTodosFromServer_updatesStateWithFetchedTodos() async {
        // Arrange
        arrange()

        // Act
        await store.send(.getRemoteTodos)

        // Assert
        await store.receive(.mainList(.updateTodos(todos)))
    }

    func test_getRemoteTodos_otherNetworkRequestPending_doNothing() async {
        // Arrange
        arrange(networkIndicatorState: .init(pendingRequestCount: 1))

        // Act
        await store.send(.getRemoteTodos)

        // Assert
    }

    func test_getRemoteTodos_requestsTodosFromServer_savesFetchedTodosInCache() async {
        // Arrange
        arrange()

        var saved = false

        cacheMock.replaceWithMock = { _ in saved = true }

        // Act
        await store.send(.getRemoteTodos)

        // Assert
        XCTAssertTrue(saved)
    }

    func test_getRemoteTodos_requestsTodosFromServer_gettingErrorWhenRequestFailed() async {
        // Arrange
        arrange()

        serviceMock.getTodosMock = { throw ErrorMock.error }

        // Act
        await store.send(.getRemoteTodos)

        // Assert
        await store.receive(.error)
    }

    func test_updateTodo_cachedDataIsCleanAndServerIsOK_updatesCachedTodo() async {
        // Arrange
        arrange()

        var updated = false

        cacheMock.updateMock = { _ in updated = true }

        // Act
        await store.send(.update(Todo(text: "A")))

        // Assert
        XCTAssertTrue(updated)
    }

    func test_updateTodo_cachedDataIsCleanAndServerIsOK_updatesRemoteTodo() async {
        // Arrange
        arrange()

        var updated = false

        serviceMock.updateRemoteMock = { _ in updated = true }

        // Act
        await store.send(.update(Todo(text: "A")))

        // Assert
        XCTAssertTrue(updated)
    }

    func test_updateTodo_cachedDataIsClean_receivingErrorWhenServerRequestFailed() async {
        // Arrange
        arrange()

        serviceMock.updateRemoteMock = { _ in throw ErrorMock.error }

        // Act
        await store.send(.update(Todo(text: "A")))

        // Assert
        await store.receive(.error)
    }

    func test_updateTodo_cachedDataIsDirty_initiatesSyncRequest() async {
        // Arrange
        arrange(isDirty: true)

        // Act
        await store.send(.update(Todo(text: "A")))

        // Assert
        await store.receive(.sync(.syncWithRemoteTodos))
    }

    func test_updateTodo_cachedDataIsDirty_updatesCachedTodoAndSetItToDirty() async {
        // Arrange
        arrange(isDirty: true)

        var updated = false

        cacheMock.updateMock = {
            if $0.isDirty {
                updated = true
            }
        }

        // Act
        await store.send(.update(Todo(text: "A")))

        // Assert
        XCTAssertTrue(updated)
    }

    func test_mainListCreateTodo_cachedDataIsCleanAndServerIsOK_savesTodoInCache() async {
        // Arrange
        arrange()

        var saved = false

        cacheMock.insertMock = { _ in saved = true }

        // Act
        await store.send(.mainList(.createTodo(todo: Todo(text: "C"))))

        // Assert
        XCTAssertTrue(saved)
    }

    func test_mainListCreateTodo_cachedDataIsCleanAndServerIsOK_createsRemoteTodo() async {
        // Arrange
        arrange()

        var created = false

        serviceMock.createRemoteMock = { _ in created = true }

        // Act
        await store.send(.mainList(.createTodo(todo: Todo(text: "C"))))

        // Assert
        XCTAssertTrue(created)
    }

    func test_mainListCreateTodo_cachedDataIsClean_receivingErrorWhenServerRequestFailed() async {
        // Arrange
        arrange()

        serviceMock.createRemoteMock = { _ in throw ErrorMock.error }

        // Act
        await store.send(.mainList(.createTodo(todo: Todo(text: "C"))))

        // Assert
        await store.receive(.error)
    }

    func test_mainListCreateTodo_cachedDataIsDirty_initiatesSyncRequest() async {
        // Arrange
        arrange(isDirty: true)

        // Act
        await store.send(.mainList(.createTodo(todo: Todo(text: "C"))))

        // Assert
        await store.receive(.sync(.syncWithRemoteTodos))
    }

    func test_mainListDeleteTodo_cachedDataIsCleanAndServerIsOK_deleteTodoFromCache() async {
        // Arrange
        arrange()

        var deleted = false

        cacheMock.deleteMock = { _ in deleted = true }

        // Act
        await store.send(.mainList(.deleteTodo(todo: Todo(text: "C"))))

        // Assert
        XCTAssertTrue(deleted)
    }

    func test_mainListDeleteTodo_cachedDataIsCleanAndServerIsOK_deleteRemoteTodo() async {
        // Arrange
        arrange()

        var deleted = false

        serviceMock.deleteRemoteMock = { _ in deleted = true }

        // Act
        await store.send(.mainList(.deleteTodo(todo: Todo(text: "C"))))

        // Assert
        XCTAssertTrue(deleted)
    }

    func test_mainListDeleteTodo_cachedDataIsClean_receivingErrorWhenServerRequestFailed() async {
        // Arrange
        arrange()

        serviceMock.deleteRemoteMock = { _ in throw ErrorMock.error }

        // Act
        await store.send(.mainList(.deleteTodo(todo: Todo(text: "C"))))

        // Assert
        await store.receive(.error)
    }

    func test_mainListDeleteTodo_cachedDataIsDirty_initiatesSyncRequest() async {
        // Arrange
        arrange(isDirty: true)

        // Act
        await store.send(.mainList(.deleteTodo(todo: Todo(text: "C"))))

        // Assert
        await store.receive(.sync(.syncWithRemoteTodos))
    }

    func test_mainListDeleteTodo_cachedDataIsCleanAndServerRequestFailed_createsTombstone() async {
        // Arrange
        arrange()

        var tombstoneCreated = false

        serviceMock.deleteRemoteMock = { _ in throw ErrorMock.error }
        tombstonesMock.insertMock = { _ in tombstoneCreated = true }

        // Act
        await store.send(.mainList(.deleteTodo(todo: Todo(text: "C"))))

        // Assert
        XCTAssertTrue(tombstoneCreated)
    }

    func test_syncWithRemoteTodosResult_success_updatesMainListWithFetchedTodos() async {
        // Arrange
        arrange()

        // Act
        await store.send(.sync(.syncWithRemoteTodosResult(.success(todos))))

        // Assert
        await store.receive(.mainList(.updateTodos(todos)))
    }

    func test_syncWithRemoteTodosResult_success_replacesSavedTodosInCache() async {
        // Arrange
        arrange()

        var replaced = false

        cacheMock.replaceWithMock = { _ in replaced = true }

        // Act
        await store.send(.sync(.syncWithRemoteTodosResult(.success(todos))))

        // Assert
        XCTAssertTrue(replaced)
    }

    func test_syncWithRemoteTodosResult_success_clearsDirtyState() async {
        // Arrange
        arrange()

        var cleared = false

        tombstonesMock.clearMock = { cleared = true }

        // Act
        await store.send(.sync(.syncWithRemoteTodosResult(.success(todos))))

        // Assert
        XCTAssertTrue(cleared)
    }
}

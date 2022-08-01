//
//  TodoListServiceOneTests.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 20.07.2021.
//

import XCTest
@testable import TodoList

// 1.3. Тесты на взаимодействие с network слоем из объекта.
class TestTodoListServiceOne: XCTestCase {

    func testFetchRemoteTodoList__whenCacheIsCleanAndNetworkIsAvailable() throws {
        // Arrange:
        let networkingServiceMock = NetworkingServiceMock()
        let todoListService = TodoListServiceOne(isRemotingEnabled: true,
                                                 cache: TodoListCacheStub(),
                                                 deadItemsCache: DeadItemsCacheStub(),
                                                 logger: LoggerStub(),
                                                 networking: networkingServiceMock,
                                                 httpRequestCounterPublisher: HttpRequestCounterPublisherStub(),
                                                 mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisherMock())
        let exp = expectation(description: "fetchRemoteTodoList")

        // Act:
        todoListService.fetchRemoteItems { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.001)

        // Assert:
        XCTAssertEqual(networkingServiceMock.fetchTodoListCallCounter, 1)
    }

    func testCreateRemote__whenCacheIsCleanAndNetworkIsAvailable() throws {
        // Arrange:
        let todoItem = TodoItem(text: "a")
        let networkingServiceMock = NetworkingServiceMock()
        let todoListService = TodoListServiceOne(isRemotingEnabled: true,
                                                 cache: TodoListCacheStub(),
                                                 deadItemsCache: DeadItemsCacheStub(),
                                                 logger: LoggerStub(),
                                                 networking: networkingServiceMock,
                                                 httpRequestCounterPublisher: HttpRequestCounterPublisherStub(),
                                                 mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisherMock())
        let exp = expectation(description: "createRemote")

        // Act:
        todoListService.createRemote(todoItem) { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.001)

        // Assert:
        XCTAssertEqual(networkingServiceMock.createTodoItemCallCounter, 1)
    }

    func testUpdateRemote__whenCacheIsCleanAndNetworkIsAvailable() throws {
        // Arrange:
        let todoItem = TodoItem(text: "a")
        let networkingServiceMock = NetworkingServiceMock()
        let todoListService = TodoListServiceOne(isRemotingEnabled: true,
                                                 cache: TodoListCacheStub(),
                                                 deadItemsCache: DeadItemsCacheStub(),
                                                 logger: LoggerStub(),
                                                 networking: networkingServiceMock,
                                                 httpRequestCounterPublisher: HttpRequestCounterPublisherStub(),
                                                 mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisherMock())
        let exp = expectation(description: "updateRemote")

        // Act:
        todoListService.updateRemote(todoItem) { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.001)

        // Assert:
        XCTAssertEqual(networkingServiceMock.updateTodoItemCallCounter, 1)
    }

    func testRemoveRemote__whenCacheIsCleanAndNetworkIsAvailable() throws {
        // Arrange:
        let todoItem = TodoItem(text: "a")
        let networkingServiceMock = NetworkingServiceMock()
        let todoListService = TodoListServiceOne(isRemotingEnabled: true,
                                                 cache: TodoListCacheStub(),
                                                 deadItemsCache: DeadItemsCacheStub(),
                                                 logger: LoggerStub(),
                                                 networking: networkingServiceMock,
                                                 httpRequestCounterPublisher: HttpRequestCounterPublisherStub(),
                                                 mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisherMock())
        let exp = expectation(description: "removeRemote")

        // Act:
        todoListService.removeRemote(todoItem) { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.001)

        // Assert:
        XCTAssertEqual(networkingServiceMock.deleteTodoItemCallCounter, 1)
    }

    func testMergeWithRemote__whenCacheIsCleanAndNetworkIsAvailable() throws {
        // Arrange:
        let networkingServiceMock = NetworkingServiceMock()
        let todoListService = TodoListServiceOne(isRemotingEnabled: true,
                                                 cache: TodoListCacheStub(),
                                                 deadItemsCache: DeadItemsCacheStub(),
                                                 logger: LoggerStub(),
                                                 networking: networkingServiceMock,
                                                 httpRequestCounterPublisher: HttpRequestCounterPublisherStub(),
                                                 mergeItemsWithRemotePublisher: MergeItemsWithRemotePublisherMock())
        let exp = expectation(description: "mergeWithRemote")

        // Act:
        todoListService.mergeWithRemote { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.001)

        // Assert:
        XCTAssertEqual(networkingServiceMock.mergeTodoListCallCounter, 1)
    }
}

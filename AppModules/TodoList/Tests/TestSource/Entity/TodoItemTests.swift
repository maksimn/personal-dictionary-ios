//
//  TodoItemTests.swift
//  CoreTodo-Unit-Tests
//
//  Created by Maxim Ivanov on 24.08.2021.
//

import XCTest
@testable import TodoList

class TodoItemTests: XCTestCase {

    func testOperatorEquality_twoEqualObjects_returnsTrue() throws {
        let todoItem1 = TodoItem(text: "a")
        let todoItem2 = todoItem1.update(text: todoItem1.text)

        let result = todoItem1 == todoItem2

        XCTAssertTrue(result)
    }
}

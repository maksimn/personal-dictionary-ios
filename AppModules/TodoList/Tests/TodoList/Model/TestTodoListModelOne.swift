//
//  TodoListModelOneTests.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

import XCTest
@testable import TodoList

// 1.1. Тесты бизнес-логики "показать/скрыть" выполненные на экране списка.
class TestTodoListModelOne: XCTestCase {

    func testToggleCompletedTodoVisibility_callWhenCompletedItemsAreNotVisible() {
        let todoList = [TodoItem(text: "a"), TodoItem(text: "b", isCompleted: true), TodoItem(text: "c"),
                        TodoItem(text: "d", isCompleted: true), TodoItem(text: "e")]
        let model = TodoListModelOne(allTodoList: todoList, areCompletedTodosVisible: false)

        model.toggleCompletedTodoVisibility()

        XCTAssertEqual(model.todoList, todoList)
    }

    func testToggleCompletedTodoVisibility_callWhenCompletedItemsAreVisible() {
        let todoList = [TodoItem(text: "a"), TodoItem(text: "b", isCompleted: true), TodoItem(text: "c"),
                        TodoItem(text: "d", isCompleted: true), TodoItem(text: "e")]
        let incompleteTodoList = [todoList[0], todoList[2], todoList[4]]
        let model = TodoListModelOne(allTodoList: todoList, areCompletedTodosVisible: true)

        model.toggleCompletedTodoVisibility()

        XCTAssertEqual(model.todoList, incompleteTodoList)
    }
}

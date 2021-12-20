//
//  Mocks.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

final class NilTodoItemTodoEditorModelMock: TodoEditorModel {

    var presenter: TodoEditorPresenter?

    var todoItem: TodoItem? {
        nil
    }

    var mode: TodoEditorMode { .creatingNew }

    var areRequestsPending: Bool = false

    func create(_ todoItem: TodoItem) { }

    func updateTodoItem(text: String, priority: TodoItemPriority, deadline: Date?) { }

    func removeTodoItem() { }

    func dispose() { }
}

final class TodoEditorModelMock: TodoEditorModel {

    let item: TodoItem

    init(_ item: TodoItem) {
        self.item = item
    }

    var todoItem: TodoItem? {
        item
    }

    var presenter: TodoEditorPresenter?

    var mode: TodoEditorMode { .creatingNew }

    var areRequestsPending: Bool = false

    func create(_ todoItem: TodoItem) { }

    func updateTodoItem(text: String, priority: TodoItemPriority, deadline: Date?) { }

    func removeTodoItem() { }

    func dispose() { }
}

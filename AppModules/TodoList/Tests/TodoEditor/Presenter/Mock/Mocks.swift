//
//  Mocks.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

final class NilTodoItemTodoEditorModelMock: TodoEditorInteractor {
    func save(_ data: TodoEditorUserInput) {

    }


    var presenter: TodoEditorPresenter?

    var todoItem: TodoItem? {
        nil
    }

    var mode: TodoEditorMode { .creatingNew }

    func removeTodoItem() { }

    func dispose() { }
}

final class TodoEditorModelMock: TodoEditorInteractor {

    func save(_ data: TodoEditorUserInput) {
    }


    let item: TodoItem

    init(_ item: TodoItem) {
        self.item = item
    }

    var todoItem: TodoItem? {
        item
    }

    var presenter: TodoEditorPresenter?

    func removeTodoItem() { }

    func dispose() { }
}

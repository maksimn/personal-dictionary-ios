//
//  Mocks.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

final class NilTodoItemEditorModelMock: EditorInteractor {
    func save(_ data: EditorUserInput) {

    }


    var presenter: EditorPresenter?

    var todoItem: TodoItem? {
        nil
    }

    var mode: EditorMode { .creatingNew }

    func removeTodoItem() { }

    func dispose() { }
}

final class EditorModelMock: EditorInteractor {

    func save(_ data: EditorUserInput) {
    }


    let item: TodoItem

    init(_ item: TodoItem) {
        self.item = item
    }

    var todoItem: TodoItem? {
        item
    }

    var presenter: EditorPresenter?

    func removeTodoItem() { }

    func dispose() { }
}

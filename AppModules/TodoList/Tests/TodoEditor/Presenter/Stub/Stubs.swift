//
//  StubsTodoEditorPresenterOne.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

class TodoEditorViewStub: TodoEditorView {

    var presenter: TodoEditorPresenter?

    func set(todoItem: TodoItem?) { }

    func setActivityIndicator(visible: Bool) { }

    func setSaveButton(enabled: Bool) { }

    var viewController: UIViewController? { nil }
}

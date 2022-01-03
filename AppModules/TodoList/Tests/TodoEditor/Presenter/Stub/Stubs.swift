//
//  StubsTodoEditorPresenterOne.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 21.07.2021.
//

@testable import TodoList

class TodoEditorViewStub: TodoEditorView {
    func setRemoveButton(enabled: Bool) {
        
    }

    func clear() {

    }

    func hide() {

    }

    func setDeadlineButton(visible: Bool) {

    }

    func updateDeadlineButtonTitle() {

    }

    func setTextPlaceholder(visible: Bool) {

    }

    func setDeadlineDatePicker(visible: Bool) {

    }

    var isDeadlineDatePickerVisible: Bool = false


    var presenter: TodoEditorPresenter?

    func set(todoItem: TodoItem?) { }

    func setSaveButton(enabled: Bool) { }
}

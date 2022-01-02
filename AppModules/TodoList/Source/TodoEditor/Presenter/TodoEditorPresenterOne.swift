//
//  TodoDetailsController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

// Technical debt.
// The code needs to be refactored.
class TodoEditorPresenterOne: TodoEditorPresenter {

    private let model: TodoEditorModel
    private weak var view: TodoEditorView?

    private var savedTodoItem: TodoItem?
    var isSaveButtonEnabled: Bool

    init(model: TodoEditorModel, view: TodoEditorView) {
        self.model = model
        self.view = view
        isSaveButtonEnabled = false
        view.setSaveButton(enabled: isSaveButtonEnabled)
        savedTodoItem = model.todoItem
    }

    func setInitialData() {
        view?.set(todoItem: model.todoItem)
    }

    func save(_ data: TodoEditorUserInput) {
        model.save(data)
        view?.hide()
    }

    func removeTodoItem() {
        model.removeTodoItem()
        view?.clear()
        view?.hide()
    }

    func setIfSaveButtonEnabledOnUserInput(_ input: TodoEditorUserInput) {
        isSaveButtonEnabled = !(savedTodoItem?.text == input.text &&
                                savedTodoItem?.priority == input.priority &&
                                savedTodoItem?.deadline == input.deadline)

        view?.setSaveButton(enabled: isSaveButtonEnabled)
    }
}

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
    private unowned let view: TodoEditorView

    private var savedTodoItem: TodoItem?
    var isSaveButtonEnabled: Bool

    init(model: TodoEditorModel, view: TodoEditorView) {
        self.model = model
        self.view = view
        isSaveButtonEnabled = false
        view.setSaveButton(enabled: isSaveButtonEnabled)
        savedTodoItem = model.todoItem
    }

    var mode: TodoEditorMode {
        model.mode
    }

    func viewSetTodoItem() {
        view.set(todoItem: model.todoItem)
    }

    func viewUpdateActivityIndicator() {
        view.setActivityIndicator(visible: model.areRequestsPending)
    }

    func create(_ todoItem: TodoItem) {
        model.create(todoItem)
    }

    func removeTodoItem() {
        model.removeTodoItem()
    }

    func updateTodoItem(_ data: TodoEditorUserInput) {
        model.updateTodoItem(text: data.text, priority: data.priority, deadline: data.deadline)
    }

    func onViewInputChanged(_ input: TodoEditorUserInput) {
        isSaveButtonEnabled = !(savedTodoItem?.text == input.text &&
                                savedTodoItem?.priority == input.priority &&
                                savedTodoItem?.deadline == input.deadline)

        view.setSaveButton(enabled: isSaveButtonEnabled)
    }

    func dispose() {
        model.dispose()
    }
}

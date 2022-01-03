//
//  TodoDetailsController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

final class TodoEditorPresenterImpl: TodoEditorPresenter {

    private let interactor: TodoEditorInteractor
    private weak var view: TodoEditorView?

    private var savedTodoItem: TodoItem?
    var isSaveButtonEnabled: Bool

    init(model: TodoEditorInteractor, view: TodoEditorView) {
        self.interactor = model
        self.view = view
        isSaveButtonEnabled = false
        view.setSaveButton(enabled: isSaveButtonEnabled)
        savedTodoItem = model.todoItem
    }

    func setInitialData() {
        view?.set(todoItem: interactor.todoItem)
        view?.setRemoveButton(enabled: interactor.todoItem != nil)
    }

    func save(_ data: TodoEditorUserInput) {
        interactor.save(data)
        view?.hide()
    }

    func removeTodoItem() {
        interactor.removeTodoItem()
        view?.clear()
        view?.hide()
    }

    func handleDeadlineSwitchValueChanged(_ value: Bool, _ input: TodoEditorUserInput) {
        if value {
            view?.setDeadlineButton(visible: true)
            view?.updateDeadlineButtonTitle()
        } else {
            view?.setDeadlineButton(visible: false)
            view?.setDeadlineDatePicker(visible: false)
        }
        setIfSaveButtonEnabledOnUserInput(input)
        view?.setRemoveButton(enabled: true)
    }

    func handleDeadlineDatePickerValueChanged(_ input: TodoEditorUserInput) {
        view?.updateDeadlineButtonTitle()
        setIfSaveButtonEnabledOnUserInput(input)
        view?.setRemoveButton(enabled: true)
    }

    func handleTextInput(_ input: TodoEditorUserInput) {
        view?.setTextPlaceholder(visible: input.text.isEmpty)
        view?.setRemoveButton(enabled: !input.text.isEmpty || input.deadline != nil || input.priority != .normal)
        setIfSaveButtonEnabledOnUserInput(input)
    }

    func setIfSaveButtonEnabledOnUserInput(_ input: TodoEditorUserInput) {
        isSaveButtonEnabled = !(savedTodoItem?.text == input.text &&
                                savedTodoItem?.priority == input.priority &&
                                savedTodoItem?.deadline == input.deadline)

        view?.setSaveButton(enabled: isSaveButtonEnabled)
    }
}

//
//  TodoListControllerOne.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

// Technical debt.
// The code needs to be refactored.
class TodoListPresenterOne: TodoListPresenter {

    private unowned let view: TodoListView
    private let model: TodoListModel
    private let todoEditorBuilder: TodoEditorBuilder

    init(model: TodoListModel, view: TodoListView, todoEditorBuilder: TodoEditorBuilder) {
        self.view = view
        self.model = model
        self.todoEditorBuilder = todoEditorBuilder
    }

    func loadTodoList() {
        model.loadTodoListFromCache()
        viewUpdate()
        model.loadTodoListFromRemote { [weak self] _ in
            self?.viewUpdate()
        }
    }

    func viewUpdate() {
        viewUpdateDataInList()
        view.reloadList()
    }

    func viewUpdateDataInList() {
        view.set(model.todoList)
    }

    func viewAddNewTodoItem() {
        view.addNewRowToList()
    }

    func viewUpdateTodoItemAt(_ position: Int) {
        view.updateRowAt(position)
    }

    func viewRemoveTodoItemAt(_ position: Int) {
        view.removeRowAt(position)
    }

    func viewExpandCompletedTodos() {
        view.expandCompletedTodos()
    }

    func viewHideCompletedTodos() {
        view.hideCompletedTodos()
    }

    func viewSetToggleTitle(for areCompletedTodoVisible: Bool) {
        view.setToggleTitle(for: areCompletedTodoVisible)
    }

    func toggleCompletedTodoVisibility() {
        model.toggleCompletedTodoVisibility()
    }

    func add(_ todoItem: TodoItem) {
        model.add(todoItem)
    }

    func remove(_ todoItem: TodoItem, _ position: Int) {
        model.remove(todoItem, position)
    }

    func toggleCompletionForTodoAt(_ position: Int) {
        model.toggleCompletionForTodoAt(position)
    }

    func navigateToEditor(_ todoItem: TodoItem?) {
        let todoEditorMVP = todoEditorBuilder.build(initTodoItem: todoItem)
        let todoEditorViewController = todoEditorMVP.viewController
        todoEditorViewController.modalPresentationStyle = .overFullScreen
        todoEditorViewController.navigationItem.largeTitleDisplayMode = .never

        let navigationController = UINavigationController(rootViewController: todoEditorViewController)

        view.viewController?.present(navigationController, animated: true, completion: nil)
    }
}

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
    private var mvp: TodoListMVP

    init(model: TodoListModel, view: TodoListView, mvp: TodoListMVP) {
        self.view = view
        self.model = model
        self.mvp = mvp
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
        viewUpdateToggleAndCompletedItemCounter()
    }

    func viewUpdateDataInList() {
        view.set(model.todoList)
    }

    func viewAddNewTodoItem() {
        view.addNewRowToList()
    }

    func viewUpdateTodoItemAt(_ position: Int) {
        view.updateRowAt(position)
        viewUpdateToggleAndCompletedItemCounter()
    }

    func viewRemoveTodoItemAt(_ position: Int) {
        view.removeRowAt(position)
        viewUpdateToggleAndCompletedItemCounter()
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

    func viewUpdateActivityIndicator() {
        view.setActivityIndicator(visible: model.areRequestsPending)
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
        let todoEditorMVP = mvp.buildTodoEditorMVP(todoItem)

        if let todoEditorViewController = todoEditorMVP.viewController {
            todoEditorViewController.modalPresentationStyle = .overFullScreen
            todoEditorViewController.navigationItem.largeTitleDisplayMode = .never

            let navigationController = UINavigationController(rootViewController: todoEditorViewController)

            view.viewController?.present(navigationController, animated: true, completion: nil)
        }
    }

    private func viewUpdateToggleAndCompletedItemCounter() {
        let completedTodoCount = model.completedTodoCount
        view.updateCompletedTodoCountView(completedTodoCount)
        view.setToggleColor(completedTodoCount == 0)
        view.setToggleTitle(for: model.areCompletedTodosVisible)
    }
}

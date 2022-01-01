//
//  TodoListViewOne.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

// Technical debt.
// The code needs to be refactored.
class TodoListViewOne: UIViewController {

    var presenter: TodoListPresenter?

    let completedTodoVisibilityToggle = UIButton()
    let completedTodoCountLabel = UILabel()
    let tableView = UITableView()
    let newTodoItemButton = UIButton()
    var tableViewBottomConstraint: NSLayoutConstraint?

    let tableController = TodoTableController()

    let keyboardEventsHandle = KeyboardEventsHandle()

    var shouldTableViewScrollToBottom: Bool = false
    var isFirstKeyboardShow: Bool = true

    let routingButton = UIButton()

    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(networkIndicatorBuilder: NetworkIndicatorBuilder) {
        self.networkIndicatorBuilder = networkIndicatorBuilder
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Strings.myTodos
        initViews()
        initKeyboardEventsHandle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.sizeToFit()
        presenter?.loadTodoList()
    }
}

extension TodoListViewOne: TodoListView {

    var viewController: UIViewController? { self }

    func set(_ todoList: [TodoItem]) {
        tableController.todoList = todoList
    }

    func setToggleTitle(for completedTodoVisibility: Bool) {
        completedTodoVisibilityToggle.setTitle(completedTodoVisibility ? Strings.hide : Strings.show, for: .normal)
    }

    func expandCompletedTodos() {
        tableView.performBatchUpdates({
            let indexPaths = self.tableController.todoList.completedTodoItemIndexPaths
            self.tableView.insertRows(at: indexPaths, with: .automatic)

            if let firstIndexPath = indexPaths.first {
                let indexPaths = self.tableView.indexPathsForVisibleRows?.filter { $0.row >= firstIndexPath.row } ?? []
                self.tableView.reloadRows(at: indexPaths, with: .automatic)
            }
        }, completion: nil)
    }

    func hideCompletedTodos() {
        tableView.performBatchUpdates({
            let previousTodoList = self.tableController.todoList
            let indexPaths = previousTodoList.completedTodoItemIndexPaths
            presenter?.viewUpdateDataInList()
            self.tableView.deleteRows(at: indexPaths, with: .automatic)
        }, completion: nil)
    }

    func updateCompletedTodoCountView(_ count: Int) {
        completedTodoCountLabel.text = "\(Strings.completed) \(count)"
    }

    func setToggleColor(_ isCompletedTodoListEmpty: Bool) {
        completedTodoVisibilityToggle.setTitleColor(isCompletedTodoListEmpty ? .systemGray : .systemBlue, for: .normal)
    }

    func addNewRowToList() {
        let count = tableController.todoList.count - 1

        tableView.insertRows(at: [IndexPath(row: count, section: 0)], with: .automatic)
    }

    func updateRowAt(_ position: Int) {
        tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
    }

    func removeRowAt(_ position: Int) {
        tableView.deleteRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
    }

    func reloadList() {
        tableView.reloadData()
    }
}

// User Action Handlers:
extension TodoListViewOne {

    @objc func onNewTodoItemButtonTap() {
        presenter?.navigateToEditor(nil)
    }

    @objc func onCompletedTodosVisibilityButtonTap() {
        presenter?.toggleCompletedTodoVisibility()
    }

    func onDeleteTodoTap(_ position: Int) {
        if position > tableController.todoList.count - 1 {
            return
        }

        let item = tableController.todoList[position]

        presenter?.remove(item, position)
    }

    func onTodoCompletionTap(_ position: Int) {
        presenter?.toggleCompletionForTodoAt(position)
    }

    func onNewTodoItemTextEnter(_ text: String) {
        let todoItem = TodoItem(text: text)

        presenter?.add(todoItem)
    }

    func onDidSelectAt(_ position: Int) {
        let todoItem = tableController.todoList[position]

        presenter?.navigateToEditor(todoItem)
    }
}

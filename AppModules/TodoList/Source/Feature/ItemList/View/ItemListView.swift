//
//  ItemListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

final class ItemListView: UIView {

    private let viewModel: ItemListViewModel

    private let navToEditorRouter: NavToEditorRouter

    private let tableView = UITableView()

    private let tableController = TodoTableController()

    private let disposeBag = DisposeBag()

    init(viewModel: ItemListViewModel,
         navToEditorRouter: NavToEditorRouter) {
        self.viewModel = viewModel
        self.navToEditorRouter = navToEditorRouter
        super.init(frame: .zero)
        initViews()
        subscribeToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func subscribeToViewModel() {
        viewModel.items
            .subscribe(onNext: { [weak self] items in
                self?.tableController.todoList = items
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

    private func onNewTodoItemTextEnter(_ text: String) {
        let todoItem = TodoItem(text: text)

        viewModel.add(todoItem)
    }

    private func onDeleteTap(_ position: Int) {
        viewModel.remove(at: position)
    }

    private func onTodoCompletionTap(_ position: Int) {
        viewModel.toggleCompletionForTodo(at: position)
    }

    private func onDidSelectAt(_ position: Int) {
        guard position > -1 && position < tableController.todoList.count else { return }

        let todoItem = tableController.todoList[position]

        navToEditorRouter.navigate(with: todoItem)
    }

    private func initViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = tableController
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        tableView.keyboardDismissMode = .onDrag
        tableController.onNewTodoItemTextEnter = self.onNewTodoItemTextEnter
        tableController.onDeleteTap = self.onDeleteTap
        tableController.onTodoCompletionTap = self.onTodoCompletionTap
        tableController.onDidSelectAt = self.onDidSelectAt
    }
}

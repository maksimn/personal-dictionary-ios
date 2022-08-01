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

    lazy var datasource = UITableViewDiffableDataSource<Int, TodoItem>(tableView: tableView) { [weak self]
        tableView, indexPath, item in
        if item.isTerminal {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewTodoItemCell.self)",
                                                           for: indexPath) as? NewTodoItemCell else {
                return UITableViewCell()
            }
            cell.onNewTodoItemTextEnter = self?.onNewTodoItemTextEnter

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoItemCell.self)",
                                                       for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }

        cell.set(todoItem: item)

        return cell
    }

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
                self?.tableController.items = items

                var items = items
                var snapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()

                items.append(TodoItem(isTerminal: true))
                snapshot.appendSections([0])
                snapshot.appendItems(items, toSection: 0)

                self?.datasource.apply(snapshot)
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
        guard position > -1 && position < tableController.items.count else { return }

        let todoItem = tableController.items[position]

        navToEditorRouter.navigate(with: todoItem)
    }

    private func initViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Theme.data.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = datasource
        tableView.backgroundColor = Theme.data.backgroundColor
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        tableView.keyboardDismissMode = .onDrag
        tableController.onDeleteTap = self.onDeleteTap
        tableController.onTodoCompletionTap = self.onTodoCompletionTap
        tableController.onDidSelectAt = self.onDidSelectAt
    }
}

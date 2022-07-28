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

    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

    private lazy var datasource = UITableViewDiffableDataSource<Int, TodoItem>(tableView: tableView) { [weak self]
        tableView, indexPath, item in
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
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

    private lazy var tableActions = ItemListViewActions(
        onDeleteTap: { [weak self] in
            self?.onDeleteTap($0)
        },
        onTodoCompletionTap: { [weak self] in
            self?.onTodoCompletionTap($0)
        },
        onDidSelectAt: { [weak self] in
            self?.onDidSelectAt($0)
        }
    )

    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
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
                var snapshot = NSDiffableDataSourceSnapshot<Int, TodoItem>()

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

    }

    private func initViews() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = datasource
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.delegate = tableActions
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
        tableView.keyboardDismissMode = .onDrag
    }
}

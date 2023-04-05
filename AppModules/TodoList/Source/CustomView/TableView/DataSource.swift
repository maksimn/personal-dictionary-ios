//
//  TodoListDataSource.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

struct DataSourceParams {
    let newCellPlaceholder: String
    let todoCellImage: TodoCellImage
    let swipeImage: SwipeImage

    struct SwipeImage {
        let inverseCompletedCircle: UIImage
        let trashImage: UIImage
    }
}

final class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    private(set) var todos: [Todo] = []

    private weak var tableView: UITableView?
    private let params: DataSourceParams
    private let theme: Theme
    private var onNewTodoTextChanged: (String) -> Void
    private var onDeleteTap: (Int) -> Void
    private var onTodoCompletionTap: (Int) -> Void
    private var onDidSelectAt: (Int) -> Void

    init(tableView: UITableView,
         params: DataSourceParams,
         theme: Theme,
         onNewTodoTextChanged: @escaping (String) -> Void,
         onDeleteTap: @escaping (Int) -> Void,
         onTodoCompletionTap: @escaping (Int) -> Void,
         onDidSelectAt: @escaping (Int) -> Void) {
        self.tableView = tableView
        self.params = params
        self.theme = theme
        self.onNewTodoTextChanged = onNewTodoTextChanged
        self.onDeleteTap = onDeleteTap
        self.onTodoCompletionTap = onTodoCompletionTap
        self.onDidSelectAt = onDidSelectAt
    }

    func unfocusTextView() {
        newTodoCell?.textView.resignFirstResponder()
    }

    func update(_ todos: [Todo], _ todoText: String) {
        update(todos)
        update(todoText)
    }

    private func update(_ todoText: String) {
        guard let cell = newTodoCell else { return }

        cell.textView.text = todoText
        cell.placeholderLabel.isHidden = todoText.count > 0
    }

    private func update(_ todos: [Todo]) {
        guard self.todos != todos else { return }

        let prev = self.todos

        self.todos = todos

        if Array.isCreateTodoOperation(todos, prev) {
            tableView?.insertRows(at: [IndexPath(row: todos.count - 1, section: 0)], with: .automatic)
        } else if Array.isUpdateTodoOperation(todos, prev) {
            for i in 0..<todos.count where prev[i] != todos[i] {
                tableView?.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
        } else if Array.isDeleteTodoOperation(todos, prev) {
            for i in 0..<prev.count {
                if (i < prev.count - 1 && prev[i] != todos[i]) || i == prev.count - 1 {
                    tableView?.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                    break
                }
            }
        } else if Array.isExpandCompletedTodosOperation(todos, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = todos.completedTodoIndexPaths
                self.tableView?.insertRows(at: indexPaths, with: .automatic)

                if let firstIndexPath = indexPaths.first {
                    let indexPaths = self.tableView?.indexPathsForVisibleRows?
                        .filter { $0.row >= firstIndexPath.row } ?? []
                    self.tableView?.reloadRows(at: indexPaths, with: .automatic)
                }
            }, completion: nil)
        } else if Array.isCollapseCompletedTodosOperation(todos, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = prev.completedTodoIndexPaths
                self.tableView?.deleteRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        } else {
            tableView?.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == todos.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewTodoCell.self)",
                                                           for: indexPath) as? NewTodoCell else {
                return UITableViewCell()
            }

            cell.set(placeholderText: params.newCellPlaceholder, theme: theme)
            cell.textView.delegate = self

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoCell.self)",
                                                       for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        let todo = todos[indexPath.row]

        cell.set(todo: todo, theme: theme, cellImage: params.todoCellImage)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < todos.count {
            if todos[indexPath.row].isCompleted {
                return
            }

            onDidSelectAt(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: "",
                                                  handler: { [weak self] (_, _, success: (Bool) -> Void) in
            self?.onTodoCompletionTap(indexPath.row)
            success(true)
        })
        completionAction.image = params.swipeImage.inverseCompletedCircle
        completionAction.backgroundColor = theme.darkGreen

        return UISwipeActionsConfiguration(actions: [completionAction])
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { [weak self] (_, _, success: (Bool) -> Void) in
            self?.onDeleteTap(indexPath.row)
            success(true)
        })

        deleteAction.image = params.swipeImage.trashImage
        deleteAction.backgroundColor = theme.darkRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private var newTodoCell: NewTodoCell? {
        tableView?.cellForRow(at: IndexPath(row: todos.count, section: 0)) as? NewTodoCell
    }
}

extension DataSource: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }

        onNewTodoTextChanged(text)
    }
}

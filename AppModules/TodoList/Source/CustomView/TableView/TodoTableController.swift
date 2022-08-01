//
//  TodoListDataSource.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

// Technical debt.
// The code needs to be refactored.
class TodoTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    private(set) var items: [TodoItem] = []

    var onNewTodoItemTextEnter: ((String) -> Void)?
    var onDeleteTap: ((Int) -> Void)?
    var onTodoCompletionTap: ((Int) -> Void)?
    var onDidSelectAt: ((Int) -> Void)?

    private weak var tableView: UITableView?

    private let hCell = TodoItemCell(frame: .zero)

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func update(_ items: [TodoItem]) {
        let prev = self.items

        self.items = items

        if isCreateItem(items, prev) {
            tableView?.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        } else if isUpdateItem(items, prev) {
            for i in 0..<items.count {
                if prev[i] != items[i] {
                    tableView?.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
            }
        } else if isDeleteItem(items, prev) {
            for i in 0..<prev.count {
                if (i < prev.count - 1 && prev[i] != items[i]) || i == prev.count - 1 {
                    tableView?.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                    break
                }
            }
        } else if isExpandCompletedItems(items, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = items.completedTodoItemIndexPaths
                self.tableView?.insertRows(at: indexPaths, with: .automatic)

                if let firstIndexPath = indexPaths.first {
                    let indexPaths = self.tableView?.indexPathsForVisibleRows?
                        .filter { $0.row >= firstIndexPath.row } ?? []
                    self.tableView?.reloadRows(at: indexPaths, with: .automatic)
                }
            }, completion: nil)
        } else if isCollapseCompletedItems(items, prev) {
            tableView?.performBatchUpdates({
                let indexPaths = prev.completedTodoItemIndexPaths
                self.tableView?.deleteRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        } else {
            tableView?.reloadData()
        }
    }

    private func isCreateItem(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.count + 1 == items.count && Array(items.prefix(prev.count)) == prev
    }

    private func isUpdateItem(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.count == items.count
    }

    private func isDeleteItem(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        if prev.count == items.count + 1 {
            var i = 0, j = 0, counter = 0

            while i < items.count {
                if items[i] == prev[j] {
                    i += 1
                    j += 1
                } else {
                    j += 1
                    counter += 1

                    if counter > 1 {
                        return false
                    }
                }
            }

            if counter == 1 {
                return true
            }
        }

        return false
    }

    private func isExpandCompletedItems(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        prev.allSatisfy({ !$0.isCompleted }) && items.contains(where: { $0.isCompleted })
    }

    private func isCollapseCompletedItems(_ items: [TodoItem], _ prev: [TodoItem]) -> Bool {
        items.allSatisfy({ !$0.isCompleted }) && prev.contains(where: { $0.isCompleted })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewTodoItemCell.self)",
                                                           for: indexPath) as? NewTodoItemCell else {
                return UITableViewCell()
            }

            cell.onNewTodoItemTextEnter = self.onNewTodoItemTextEnter

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TodoItemCell.self)",
                                                       for: indexPath) as? TodoItemCell else {
            return UITableViewCell()
        }
        let todoItem = items[indexPath.row]

        cell.set(todoItem: todoItem)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < items.count {
            if items[indexPath.row].isCompleted {
                return
            }

            onDidSelectAt?(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == items.count {
            return NewTodoItemCell.cellHeight
        }

        hCell.set(todoItem: items[indexPath.row])
        hCell.layoutSubviews()

        return hCell.computedHeight
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: "",
                                             handler: { (_, _, success: (Bool) -> Void) in
                                                self.onTodoCompletionTap?(indexPath.row)
                                                success(true)
                                             })
        completionAction.image = Theme.image.completedTodoMarkInverse
        completionAction.backgroundColor = Theme.data.darkGreen

        return UISwipeActionsConfiguration(actions: [completionAction])
     }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "",
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = Theme.image.trashImage
        deleteAction.backgroundColor = Theme.data.darkRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
     }
}

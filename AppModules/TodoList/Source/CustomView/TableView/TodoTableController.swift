//
//  TodoListDataSource.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

class TodoTableController: NSObject, UITableViewDelegate {

    var items: [TodoItem] = []

    var onDeleteTap: ((Int) -> Void)?
    var onTodoCompletionTap: ((Int) -> Void)?
    var onDidSelectAt: ((Int) -> Void)?

    private let hCell = TodoItemCell(frame: .zero)

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

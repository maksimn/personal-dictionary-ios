//
//  ItemListViewActions.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class ItemListViewActions: NSObject, UITableViewDelegate {

    var onDeleteTap: ((Int) -> Void)?
    var onTodoCompletionTap: ((Int) -> Void)?
    var onDidSelectAt: ((Int) -> Void)?

    init(onDeleteTap: ((Int) -> Void)?,
        onTodoCompletionTap: ((Int) -> Void)?,
        onDidSelectAt: ((Int) -> Void)?) {
        self.onDeleteTap = onDeleteTap
        self.onTodoCompletionTap = onTodoCompletionTap
        self.onDidSelectAt = onDidSelectAt
        super.init()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectAt?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            return NewTodoItemCell.cellHeight
        }

        return NewTodoItemCell.cellHeight + 20
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completionAction = UIContextualAction(style: .normal, title: Strings.empty,
                                             handler: { (_, _, success: (Bool) -> Void) in
                                                self.onTodoCompletionTap?(indexPath.row)
                                                success(true)
                                             })
        completionAction.image = Images.completedTodoMarkInverse
        completionAction.backgroundColor = Colors.darkGreen

        return UISwipeActionsConfiguration(actions: [completionAction])
     }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: Strings.empty,
                                              handler: { (_, _, success: (Bool) -> Void) in
                                                self.onDeleteTap?(indexPath.row)
                                                success(true)
                                              })

        deleteAction.image = Images.trashImage
        deleteAction.backgroundColor = Colors.darkRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
     }
}

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

    var todoList: [TodoItem] = []

    var onNewTodoItemTextEnter: ((String) -> Void)?
    var onDeleteTap: ((Int) -> Void)?
    var onTodoCompletionTap: ((Int) -> Void)?
    var onDidSelectAt: ((Int) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == todoList.count {
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
        let todoItem = todoList[indexPath.row]

        cell.set(todoItem: todoItem)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < todoList.count {
            if todoList[indexPath.row].isCompleted {
                return
            }

            onDidSelectAt?(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == todoList.count {
            return NewTodoItemCell.cellHeight
        }

        let todoItem = todoList[indexPath.row]

        return TodoItemCell.height(for: todoItem.text, cellWidth: UIScreen.main.bounds.width,
                                   priority: todoItem.priority, showDeadline: todoItem.deadline != nil)
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

//
//  TodoListView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

// Technical debt.
// The code needs to be refactored.
protocol TodoListView: AnyObject {

    var presenter: TodoListPresenter? { get set }

    var viewController: UIViewController? { get }

    func set(_ todoList: [TodoItem])

    func setToggleTitle(for areCompletedTodoVisible: Bool)

    func setToggleColor(_ isCompletedTodoListEmpty: Bool)

    func expandCompletedTodos()

    func hideCompletedTodos()

    func addNewRowToList()

    func updateRowAt(_ position: Int)

    func removeRowAt(_ position: Int)

    func reloadList()
}

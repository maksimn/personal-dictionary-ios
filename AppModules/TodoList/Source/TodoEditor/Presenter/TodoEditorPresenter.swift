//
//  TodoDetailsController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

struct TodoEditorUserInput {
    let text: String
    let priority: TodoItemPriority
    let deadline: Date?
}

protocol TodoEditorPresenter: AnyObject {

    var mode: TodoEditorMode { get }

    func viewSetTodoItem()

    func viewUpdateActivityIndicator()

    func updateTodoItem(_ data: TodoEditorUserInput)

    func create(_ todoItem: TodoItem)

    func removeTodoItem()

    func onViewInputChanged(_ input: TodoEditorUserInput)

    func dispose()
}

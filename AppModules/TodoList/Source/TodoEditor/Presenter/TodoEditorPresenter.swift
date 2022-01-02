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

// Technical debt.
// The code needs to be refactored.
protocol TodoEditorPresenter: AnyObject {

    func setInitialData()

    func save(_ data: TodoEditorUserInput)

    func removeTodoItem()

    func setIfSaveButtonEnabledOnUserInput(_ input: TodoEditorUserInput)
}

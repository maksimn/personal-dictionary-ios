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

    func setInitialData()

    func save(_ data: TodoEditorUserInput)

    func removeTodoItem()

    func handleDeadlineSwitchValueChanged(_ value: Bool, _ input: TodoEditorUserInput)

    func handleDeadlineDatePickerValueChanged(_ input: TodoEditorUserInput)

    func handleTextInput(_ input: TodoEditorUserInput)

    func setIfSaveButtonEnabledOnUserInput(_ input: TodoEditorUserInput)
}

//
//  TodoDetailsController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

struct EditorUserInput {
    let text: String
    let priority: TodoItemPriority
    let deadline: Date?
}

protocol EditorPresenter: AnyObject {

    func setInitialData()

    func save(_ data: EditorUserInput)

    func removeTodoItem()

    func handleDeadlineSwitchValueChanged(_ value: Bool, _ input: EditorUserInput)

    func handleDeadlineDatePickerValueChanged(_ input: EditorUserInput)

    func handleTextInput(_ input: EditorUserInput)

    func setIfSaveButtonEnabledOnUserInput(_ input: EditorUserInput)
}

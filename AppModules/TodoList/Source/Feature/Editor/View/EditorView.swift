//
//  TodoDetailsView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

protocol EditorView: AnyObject {

    var presenter: EditorPresenter? { get set }

    func set(todoItem: TodoItem?)

    func setSaveButton(enabled: Bool)

    func setRemoveButton(enabled: Bool)

    func clear()

    func hide()

    func setDeadlineButton(visible: Bool)

    func updateDeadlineButtonTitle()

    func setTextPlaceholder(visible: Bool)

    func setDeadlineDatePicker(visible: Bool)

    var isDeadlineDatePickerVisible: Bool { get }
}

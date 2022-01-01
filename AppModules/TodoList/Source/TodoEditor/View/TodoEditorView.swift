//
//  TodoDetailsView.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import UIKit

protocol TodoEditorView: AnyObject {

    var presenter: TodoEditorPresenter? { get set }

    func set(todoItem: TodoItem?)

    func setSaveButton(enabled: Bool)
}

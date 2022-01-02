//
//  TodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import Foundation

enum TodoEditorMode {
    case creatingNew
    case editingExisting
}

// Technical debt.
// The code needs to be refactored.
protocol TodoEditorModel {

    var presenter: TodoEditorPresenter? { get set }

    var todoItem: TodoItem? { get }

    func save(_ data: TodoEditorUserInput)

    func removeTodoItem()
}

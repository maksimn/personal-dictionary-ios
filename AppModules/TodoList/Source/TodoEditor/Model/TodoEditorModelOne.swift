//
//  MyTodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import Foundation

// Technical debt.
// The code needs to be refactored.
class TodoEditorModelOne: TodoEditorModel {

    weak var presenter: TodoEditorPresenter? {
        didSet {
            presenter?.setInitialData()
        }
    }

    private(set) var todoItem: TodoItem?
    private var mode: TodoEditorMode

    private let service: TodoListService

    init(_ todoItem: TodoItem?, _ service: TodoListService) {
        self.service = service
        self.todoItem = todoItem
        mode = todoItem == nil ? .creatingNew : .editingExisting
    }

    func save(_ data: TodoEditorUserInput) {
        if mode == .editingExisting {
            updateTodoItem(data)
        } else {
            createTodoItem(data)
        }
    }

    func removeTodoItem() {
        guard let todoItem = todoItem else { return }
        self.mode = .creatingNew
        self.todoItem = nil
        NotificationCenter.default.post(name: .removeTodoItem, object: self,
                                        userInfo: [Notification.Name.removeTodoItem: todoItem])
        service.removeRemote(todoItem) { _ in

        }
    }

    private func createTodoItem(_ data: TodoEditorUserInput) {
        let newTodoItem = TodoItem(text: data.text, priority: data.priority, deadline: data.deadline)
        self.todoItem = newTodoItem
        self.mode = .editingExisting
        NotificationCenter.default.post(name: .createTodoItem, object: self,
                                        userInfo: [Notification.Name.createTodoItem: newTodoItem])
        service.createRemote(newTodoItem) { _ in

        }
    }

    private func updateTodoItem(_ data: TodoEditorUserInput) {
        guard let todoItem = todoItem else { return }

        let updatedTodoItem = todoItem.update(text: data.text, priority: data.priority, deadline: data.deadline)

        self.todoItem = updatedTodoItem
        self.mode = .editingExisting
        NotificationCenter.default.post(name: .updateTodoItem, object: self,
                                        userInfo: [Notification.Name.updateTodoItem: updatedTodoItem])
        service.updateRemote(updatedTodoItem) { _ in

        }
    }
}

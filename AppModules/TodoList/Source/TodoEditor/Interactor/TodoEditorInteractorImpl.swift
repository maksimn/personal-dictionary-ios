//
//  MyTodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import Foundation

enum TodoEditorMode {
    case creatingNew
    case editingExisting
}

final class TodoEditorInteractorImpl: TodoEditorInteractor {

    weak var presenter: TodoEditorPresenter? {
        didSet {
            presenter?.setInitialData()
        }
    }

    private(set) var todoItem: TodoItem?
    private var mode: TodoEditorMode

    private let service: TodoListService
    private let updatedTodoItemPublisher: UpdatedTodoItemPublisher?
    private let deletedTodoItemPublisher: DeletedTodoItemPublisher?

    init(
        todoItem: TodoItem?,
        service: TodoListService,
        updatedTodoItemPublisher: UpdatedTodoItemPublisher?,
        deletedTodoItemPublisher: DeletedTodoItemPublisher?
    ) {
        self.service = service
        self.todoItem = todoItem
        self.deletedTodoItemPublisher = deletedTodoItemPublisher
        self.updatedTodoItemPublisher = updatedTodoItemPublisher
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
        deletedTodoItemPublisher?.send(todoItem)
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
        updatedTodoItemPublisher?.send(UpdatedTodoItemData(newValue: updatedTodoItem, oldValue: todoItem))
        service.updateRemote(updatedTodoItem) { _ in

        }
    }
}

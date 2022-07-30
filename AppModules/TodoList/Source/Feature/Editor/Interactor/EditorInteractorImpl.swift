//
//  MyTodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import Foundation

enum EditorMode {
    case creatingNew
    case editingExisting
}

final class EditorInteractorImpl: EditorInteractor {

    weak var presenter: EditorPresenter? {
        didSet {
            presenter?.setInitialData()
        }
    }

    private(set) var todoItem: TodoItem?
    private var mode: EditorMode

    private let createdTodoItemPublisher: CreatedTodoItemPublisher
    private let updatedTodoItemPublisher: UpdatedTodoItemPublisher
    private let deletedTodoItemPublisher: DeletedTodoItemPublisher

    init(todoItem: TodoItem?,
         createdTodoItemPublisher: CreatedTodoItemPublisher,
         updatedTodoItemPublisher: UpdatedTodoItemPublisher,
         deletedTodoItemPublisher: DeletedTodoItemPublisher) {
        self.todoItem = todoItem
        self.createdTodoItemPublisher = createdTodoItemPublisher
        self.deletedTodoItemPublisher = deletedTodoItemPublisher
        self.updatedTodoItemPublisher = updatedTodoItemPublisher
        mode = todoItem == nil ? .creatingNew : .editingExisting
    }

    func save(_ data: EditorUserInput) {
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
        deletedTodoItemPublisher.send(todoItem)
    }

    private func createTodoItem(_ data: EditorUserInput) {
        let newTodoItem = TodoItem(text: data.text, priority: data.priority, deadline: data.deadline)
        self.todoItem = newTodoItem
        self.mode = .editingExisting
        createdTodoItemPublisher.send(newTodoItem)
    }

    private func updateTodoItem(_ data: EditorUserInput) {
        guard let todoItem = todoItem else { return }

        var updatedTodoItem = todoItem.update(text: data.text, priority: data.priority)

        updatedTodoItem.deadline = data.deadline
        self.todoItem = updatedTodoItem
        self.mode = .editingExisting
        updatedTodoItemPublisher.send(UpdatedTodoItemData(newValue: updatedTodoItem, oldValue: todoItem))
    }
}

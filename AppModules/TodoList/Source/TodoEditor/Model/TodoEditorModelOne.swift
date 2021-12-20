//
//  MyTodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

import Foundation

class TodoEditorModelOne: TodoEditorModel {

    weak var presenter: TodoEditorPresenter? {
        didSet {
            presenter?.viewSetTodoItem()
        }
    }

    private(set) var todoItem: TodoItem?
    private(set) var mode: TodoEditorMode

    private let service: TodoListService

    init(_ todoItem: TodoItem?, _ service: TodoListService) {
        self.service = service
        self.todoItem = todoItem
        mode = todoItem == nil ? .creatingNew : .editingExisting
        addNotificationObservers()
    }

    var areRequestsPending: Bool {
        service.areRequestsPending
    }

    func create(_ todoItem: TodoItem) {
        self.todoItem = todoItem
        self.mode = .editingExisting
        NotificationCenter.default.post(name: .createTodoItem, object: self,
                                        userInfo: [Notification.Name.createTodoItem: todoItem])
        service.createRemote(todoItem) { _ in

        }
    }

    func updateTodoItem(text: String, priority: TodoItemPriority, deadline: Date?) {
        guard let todoItem = todoItem else { return }

        let updatedTodoItem = todoItem.update(text: text, priority: priority, deadline: deadline)

        self.todoItem = updatedTodoItem
        self.mode = .editingExisting
        NotificationCenter.default.post(name: .updateTodoItem, object: self,
                                        userInfo: [Notification.Name.updateTodoItem: updatedTodoItem])
        service.updateRemote(updatedTodoItem) { _ in

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

    func dispose() {
        removeNotificationObservers()
    }

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onHttpRequestCounterIncrement),
                                               name: .httpRequestCounterIncrement, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHttpRequestCounterDecrement),
                                               name: .httpRequestCounterDecrement, object: nil)
    }

    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .httpRequestCounterIncrement, object: nil)
        NotificationCenter.default.removeObserver(self, name: .httpRequestCounterDecrement, object: nil)
    }

    @objc func onHttpRequestCounterIncrement(_ notification: Notification) {
        presenter?.viewUpdateActivityIndicator()
    }

    @objc func onHttpRequestCounterDecrement(_ notification: Notification) {
        presenter?.viewUpdateActivityIndicator()
    }
}
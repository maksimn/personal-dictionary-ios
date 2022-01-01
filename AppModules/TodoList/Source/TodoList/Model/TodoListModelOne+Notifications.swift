//
//  TodoListModelOne+Notifications.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 24.06.2021.
//

import Foundation

extension TodoListModelOne {

    func addNotificationObservers() {
        let ncd = NotificationCenter.default

        ncd.addObserver(self, selector: #selector(onCreateTodoItemEvent), name: .createTodoItem, object: nil)
        ncd.addObserver(self, selector: #selector(onUpdateTodoItemEvent), name: .updateTodoItem, object: nil)
        ncd.addObserver(self, selector: #selector(onDeleteTodoItemEvent), name: .removeTodoItem, object: nil)
        ncd.addObserver(self, selector: #selector(onMergeTodoListSuccess), name: .mergeTodoListWithRemoteSuccess,
                        object: nil)
    }

    @objc func onCreateTodoItemEvent(_ notification: Notification) {
        if let todoItem = notification.userInfo?[Notification.Name.createTodoItem] as? TodoItem {
            addInMemory(todoItem)
        }
    }

    @objc func onUpdateTodoItemEvent(_ notification: Notification) {
        if let todoItem = notification.userInfo?[Notification.Name.updateTodoItem] as? TodoItem {
            updateInMemory(todoItem)
        }
    }

    @objc func onDeleteTodoItemEvent(_ notification: Notification) {
        if let todoItem = notification.userInfo?[Notification.Name.removeTodoItem] as? TodoItem,
           let position = todoList.firstIndex(where: { $0.id == todoItem.id }) {
            removeInMemory(todoItem, position)
        }
    }

    @objc func onMergeTodoListSuccess(_ notification: Notification) {
        loadTodoListFromCache()
        presenter?.viewUpdate()
    }
}

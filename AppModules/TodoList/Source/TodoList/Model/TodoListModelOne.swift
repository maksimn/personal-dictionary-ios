//
//  TodoListModelOne.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 20.06.2021.
//

import UIKit

class TodoListModelOne: TodoListModel {

    weak var presenter: TodoListPresenter?

    private let service: TodoListService?

    private var allTodoList: [TodoItem] {
        didSet {
            presenter?.viewUpdateDataInList()
        }
    }

    private(set) var areCompletedTodosVisible: Bool

    init(_ service: TodoListService? = nil,
         allTodoList: [TodoItem] = [],
         areCompletedTodosVisible: Bool = false) {
        self.service = service
        self.allTodoList = allTodoList
        self.areCompletedTodosVisible = areCompletedTodosVisible
        self.addNotificationObservers()
    }

    var todoList: [TodoItem] {
        areCompletedTodosVisible ? allTodoList : allTodoList.filter { !$0.isCompleted }
    }

    var completedTodoCount: Int {
        allTodoList.filter { $0.isCompleted }.count
    }

    var areRequestsPending: Bool {
        service?.areRequestsPending ?? false
    }

    func loadTodoListFromCache() {
        allTodoList = service?.cachedTodoList ?? []
    }

    func loadTodoListFromRemote(_ completion: @escaping (Error?) -> Void) {
        service?.fetchRemoteTodoList { [weak self] _ in
            self?.allTodoList = self?.service?.cachedTodoList ?? []
            completion(nil)
        }
    }

    func add(_ todoItem: TodoItem) {
        addInMemory(todoItem)
        service?.createRemote(todoItem) { _ in

        }
    }

    func remove(_ todoItem: TodoItem, _ position: Int) {
        removeInMemory(todoItem, position)
        service?.removeRemote(todoItem) { _ in

        }
    }

    func update(_ todoItem: TodoItem) {
        updateInMemory(todoItem)
        service?.updateRemote(todoItem) { _ in

        }
    }

    func addInMemory(_ todoItem: TodoItem) {
        allTodoList.append(todoItem)
        presenter?.viewAddNewTodoItem()
    }

    func updateInMemory(_ todoItem: TodoItem) {
        if let index = allTodoList.firstIndex(where: { $0.id == todoItem.id}) {
            allTodoList[index] = todoItem
            let todoList = self.todoList
            if let position = todoList.firstIndex(where: { $0.id == todoItem.id}) {
                self.presenter?.viewUpdateTodoItemAt(position)
            }
        }
    }

    func removeInMemory(_ todoItem: TodoItem, _ position: Int) {
        if let index = allTodoList.firstIndex(where: { $0.id == todoItem.id }) {
            allTodoList.remove(at: index)
            self.presenter?.viewRemoveTodoItemAt(position)
        }
    }

    func toggleCompletionForTodoAt(_ position: Int) {
        let item = todoList[position]
        let newItem = item.update(isCompleted: !item.isCompleted)

        if let index = allTodoList.firstIndex(where: { $0.id == item.id }) {
            allTodoList[index] = newItem

            if !areCompletedTodosVisible {
                presenter?.viewRemoveTodoItemAt(position)
            } else {
                presenter?.viewUpdateTodoItemAt(position)
            }

            service?.updateRemote(newItem) { _ in

            }
        }
    }

    func toggleCompletedTodoVisibility() {
        if completedTodoCount == 0 {
            return
        }

        areCompletedTodosVisible = !areCompletedTodosVisible
        presenter?.viewSetToggleTitle(for: areCompletedTodosVisible)

        if areCompletedTodosVisible {
            presenter?.viewUpdateDataInList()
            presenter?.viewExpandCompletedTodos()
        } else {
            presenter?.viewHideCompletedTodos()
        }
    }
}

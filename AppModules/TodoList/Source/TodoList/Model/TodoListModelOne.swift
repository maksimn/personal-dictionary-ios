//
//  TodoListModelOne.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 20.06.2021.
//

import RxSwift
import UIKit

// Technical debt.
// The code needs to be refactored.
class TodoListModelOne: TodoListModel {

    weak var presenter: TodoListPresenter?

    private let service: TodoListService?

    private var allTodoList: [TodoItem] {
        didSet {
            presenter?.viewUpdateDataInList()
        }
    }

    private(set) var areCompletedTodosVisible: Bool

    private let disposeBag = DisposeBag()

    private let updatedTodoItemStream: UpdatedTodoItemStream?
    private let deletedTodoItemStream: DeletedTodoItemStream?

    init(
        service: TodoListService? = nil,
        allTodoList: [TodoItem] = [],
        areCompletedTodosVisible: Bool = false,
        updatedTodoItemStream: UpdatedTodoItemStream?,
        deletedTodoItemStream: DeletedTodoItemStream?
    ) {
        self.service = service
        self.allTodoList = allTodoList
        self.areCompletedTodosVisible = areCompletedTodosVisible
        self.updatedTodoItemStream = updatedTodoItemStream
        self.deletedTodoItemStream = deletedTodoItemStream
        self.addNotificationObservers()
    }

    var todoList: [TodoItem] {
        areCompletedTodosVisible ? allTodoList : allTodoList.filter { !$0.isCompleted }
    }

    var completedTodoCount: Int {
        allTodoList.filter { $0.isCompleted }.count
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
        deletedTodoItemStream?.send(todoItem)
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

    func toggleCompletionForTodoAt(_ position: Int) {
        let item = todoList[position]
        let newItem = item.update(isCompleted: !item.isCompleted)

        updatedTodoItemStream?.send(UpdatedTodoItemData(newValue: newItem, oldValue: item))

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

    var isCompletedItemsEmpty: Bool {
        service?.isCompletedItemsEmpty ?? true
    }

    private func onUpdate(data: UpdatedTodoItemData) {
        updateInMemory(data.newValue)
    }

    private func onDeleted(todoItem: TodoItem) {
        if let position = todoList.firstIndex(where: { $0.id == todoItem.id }) {
            removeInMemory(todoItem, position)
        }
    }

    private func updateInMemory(_ todoItem: TodoItem) {
        if let index = allTodoList.firstIndex(where: { $0.id == todoItem.id}) {
            allTodoList[index] = todoItem
            let todoList = self.todoList
            if let position = todoList.firstIndex(where: { $0.id == todoItem.id}) {
                self.presenter?.viewUpdateTodoItemAt(position)
            }
        }
    }

    private func removeInMemory(_ todoItem: TodoItem, _ position: Int) {
        if let index = allTodoList.firstIndex(where: { $0.id == todoItem.id }) {
            allTodoList.remove(at: index)
            self.presenter?.viewRemoveTodoItemAt(position)
        }
    }

    private func addNotificationObservers() {
        let ncd = NotificationCenter.default

        ncd.addObserver(self, selector: #selector(onCreateTodoItemEvent), name: .createTodoItem, object: nil)
        ncd.addObserver(self, selector: #selector(onMergeTodoListSuccess), name: .mergeTodoListWithRemoteSuccess,
                        object: nil)
        updatedTodoItemStream?.updatedTodoItemData
            .subscribe(onNext: { [weak self] in self?.onUpdate(data: $0) })
            .disposed(by: disposeBag)
        deletedTodoItemStream?.deletedTodoItem
            .subscribe(onNext: { [weak self] in self?.onDeleted(todoItem: $0) })
            .disposed(by: disposeBag)
    }

    @objc func onCreateTodoItemEvent(_ notification: Notification) {
        if let todoItem = notification.userInfo?[Notification.Name.createTodoItem] as? TodoItem {
            addInMemory(todoItem)
        }
    }

    @objc func onMergeTodoListSuccess(_ notification: Notification) {
        loadTodoListFromCache()
        presenter?.viewUpdate()
    }
}

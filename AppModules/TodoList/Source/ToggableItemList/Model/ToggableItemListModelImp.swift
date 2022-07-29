//
//  ToggableItemListModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class ToggableItemListModelImp: ToggableItemListModel, ItemListDelegate {

    private(set) var state: ToggableItemListState {
        didSet {
            if viewModel == nil {
                viewModel = viewModelBlock()
            }

            viewModel?.state.accept(state)
        }
    }
    private let service: TodoListService
    private let cudSubscriber: TodoItemCUDSubscriber
    private var allItems: [TodoItem]
    private let viewModelBlock: () -> ToggableItemListViewModel?
    private weak var viewModel: ToggableItemListViewModel?
    private let disposeBag = DisposeBag()

    init(initialState: ToggableItemListState,
         allItems: [TodoItem] = [],
         service: TodoListService,
         cudSubscriber: TodoItemCUDSubscriber,
         viewModelBlock: @escaping () -> ToggableItemListViewModel?) {
        self.state = initialState
        self.allItems = allItems
        self.service = service
        self.cudSubscriber = cudSubscriber
        self.viewModelBlock = viewModelBlock
        subscribeToTodoItemCUDEvents()
    }

    func load() {
        setState()
        service.fetchRemoteTodoList { [weak self] _ in
            self?.setState()
        }
    }

    func toggleCompletedTodoVisibility() {
        if state.completedItemCount == 0 {
            return
        }

        state.areCompletedTodosVisible = !state.areCompletedTodosVisible
        state.items = state.areCompletedTodosVisible ? allItems : allItems.filter { !$0.isCompleted }
    }

    func shouldCreate(todoItem: TodoItem) {
        allItems.append(todoItem)
        state.items.append(todoItem)
        service.createRemote(todoItem) { _ in

        }
    }

    func shouldUpdate(data: UpdatedTodoItemData, index: Int) {
        if state.areCompletedTodosVisible {
            state.items[index] = data.newValue
        } else if index > -1 && index < state.items.count {
            state.items.remove(at: index)
        }

        if !data.oldValue.isCompleted && data.newValue.isCompleted {
            state.completedItemCount += 1
        } else if state.completedItemCount > 0 && data.oldValue.isCompleted && !data.newValue.isCompleted {
            state.completedItemCount -= 1
        }

        service.updateRemote(data.newValue) { _ in }
    }

    func shouldDelete(todoItem: TodoItem, index: Int) {
        if index > -1 && index < state.items.count {
            state.items.remove(at: index)
        }

        if state.completedItemCount > 0 && todoItem.isCompleted {
            state.completedItemCount -= 1
        }

        service.removeRemote(todoItem) { _ in }
    }

    private func update(data: UpdatedTodoItemData) {
        if let index = state.items.firstIndex(where: { $0.id == data.newValue.id }) {
            shouldUpdate(data: data, index: index)
        }
    }

    private func delete(todoItem: TodoItem) {
        if let index = state.items.firstIndex(where: { $0.id == todoItem.id }) {
            shouldDelete(todoItem: todoItem, index: index)
        }
    }

    private func subscribeToTodoItemCUDEvents() {
        cudSubscriber.todoItem.subscribe(onNext: { [weak self] todoItem in
            self?.shouldCreate(todoItem: todoItem)
        }).disposed(by: disposeBag)
        cudSubscriber.updatedTodoItemData.subscribe(onNext: { [weak self] data in
            self?.update(data: data)
        }).disposed(by: disposeBag)
        cudSubscriber.deletedTodoItem.subscribe(onNext: { [weak self] item in
            self?.delete(todoItem: item)
        }).disposed(by: disposeBag)
        cudSubscriber.mergeSuccess.subscribe(onNext: { [weak self] _ in
            self?.setState()
        }).disposed(by: disposeBag)
    }

    private func setState() {
        allItems = service.cachedTodoList
        state.items = state.areCompletedTodosVisible ? allItems : allItems.filter { !$0.isCompleted }
        state.completedItemCount = allItems.filter { $0.isCompleted }.count
    }
}

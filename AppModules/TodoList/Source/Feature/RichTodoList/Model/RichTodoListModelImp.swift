//
//  RichTodoListModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class RichTodoListModelImp: RichTodoListModel, ItemListDelegate {

    private(set) var state: RichTodoListState {
        didSet {
            if viewModel == nil {
                viewModel = viewModelBlock()
            }

            viewModel?.state.accept(state)
        }
    }
    private let service: TodoListService
    private let cudSubscriber: TodoItemCUDSubscriber
    private let viewModelBlock: () -> RichTodoListViewModel?
    private weak var viewModel: RichTodoListViewModel?
    private let disposeBag = DisposeBag()

    init(initialState: RichTodoListState,
         service: TodoListService,
         cudSubscriber: TodoItemCUDSubscriber,
         viewModelBlock: @escaping () -> RichTodoListViewModel?) {
        self.state = initialState
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
    }

    func shouldCreate(todoItem: TodoItem) {
        state.items.append(todoItem)
        service.createRemote(todoItem) { _ in

        }
    }

    func shouldUpdate(data: UpdatedTodoItemData) {
        guard let index = state.items.firstIndex(where: { $0.id == data.newValue.id }) else {
            return
        }

        state.items[index] = data.newValue

        if !data.oldValue.isCompleted && data.newValue.isCompleted {
            state.completedItemCount += 1
        } else if state.completedItemCount > 0 && data.oldValue.isCompleted && !data.newValue.isCompleted {
            state.completedItemCount -= 1
        }

        service.updateRemote(data.newValue) { _ in
            
        }
    }

    func shouldDelete(todoItem: TodoItem) {
        guard let index = state.items.firstIndex(where: { $0.id == todoItem.id }) else {
            return
        }

        state.items.remove(at: index)

        if state.completedItemCount > 0 && todoItem.isCompleted {
            state.completedItemCount -= 1
        }

        service.removeRemote(todoItem) { _ in
        }
    }

    private func subscribeToTodoItemCUDEvents() {
        cudSubscriber.todoItem.subscribe(onNext: { [weak self] todoItem in
            self?.shouldCreate(todoItem: todoItem)
        }).disposed(by: disposeBag)
        cudSubscriber.updatedTodoItemData.subscribe(onNext: { [weak self] data in
            self?.shouldUpdate(data: data)
        }).disposed(by: disposeBag)
        cudSubscriber.deletedTodoItem.subscribe(onNext: { [weak self] item in
            self?.shouldDelete(todoItem: item)
        }).disposed(by: disposeBag)
        cudSubscriber.mergeSuccess.subscribe(onNext: { [weak self] _ in
            self?.setState()
        }).disposed(by: disposeBag)
    }

    private func setState() {
        state.items = service.cachedTodoList
        state.completedItemCount = state.items.filter { $0.isCompleted }.count
    }
}

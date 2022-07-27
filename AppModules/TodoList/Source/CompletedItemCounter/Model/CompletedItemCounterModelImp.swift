//
//  CompletedItemCounterModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class CompletedItemCounterModelImp: CompletedItemCounterModel {

    private(set) var count: Int {
        didSet {
            if viewModel == nil {
               viewModel = viewModelClosure()
            }

            viewModel?.count.accept(count)
        }
    }

    private let viewModelClosure: () -> CompletedItemCounterViewModel?

    private weak var viewModel: CompletedItemCounterViewModel?

    private let disposeBag = DisposeBag()

    init(
        viewModelClosure: @escaping () -> CompletedItemCounterViewModel?,
        initialCount: Int,
        updatedTodoItemSubscriber: UpdatedTodoItemSubscriber,
        deletedTodoItemSubscriber: DeletedTodoItemSubscriber
    ) {
        self.viewModelClosure = viewModelClosure
        count = initialCount
        updatedTodoItemSubscriber.updatedTodoItemData
            .subscribe(onNext: { [weak self] in self?.onUpdate(data: $0) })
            .disposed(by: disposeBag)
        deletedTodoItemSubscriber.deletedTodoItem
            .subscribe(onNext: { [weak self] in self?.onDeleted(todoItem: $0) })
            .disposed(by: disposeBag)
    }

    private func onUpdate(data: UpdatedTodoItemData) {
        if !data.oldValue.isCompleted && data.newValue.isCompleted {
            count += 1
        } else if count > 0 && data.oldValue.isCompleted && !data.newValue.isCompleted {
            count -= 1
        }
    }

    private func onDeleted(todoItem: TodoItem) {
        if count > 0 && todoItem.isCompleted {
            count -= 1
        }
    }
}

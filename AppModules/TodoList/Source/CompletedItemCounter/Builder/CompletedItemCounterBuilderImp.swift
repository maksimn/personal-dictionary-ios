//
//  CompletedItemCounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CompletedItemCounterBuilderImp: CompletedItemCounterBuilder {

    func build() -> UIView {
        let initialCount = MOTodoListCache.instance.completedItemCount
        let text = "Выполнено — "
        weak var viewModelLazy: CompletedItemCounterViewModel?

        let model = CompletedItemCounterModelImp(
            viewModelClosure: { viewModelLazy },
            initialCount: initialCount,
            completedItemCountStream: CompletedItemCountStreamImp.instance,
            updatedTodoItemSubscriber: UpdatedTodoItemStreamImp.instance,
            deletedTodoItemSubscriber: DeletedTodoItemStreamImp.instance
        )
        let viewModel = CompletedItemCounterViewModelImp(model: model)
        let view = CompletedItemCounterView(
            viewModel: viewModel,
            text: text
        )

        viewModelLazy = viewModel

        return view
    }
}

//
//  CompletedItemCounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CompletedItemCounterGraphImp: CompletedItemCounterGraph {

    let view: UIView

    private(set) weak var model: CompletedItemCounterModel?

    init() {
        let initialCount = MOTodoListCache.instance.completedItemCount
        let text = "Выполнено — "
        weak var viewModelLazy: CompletedItemCounterViewModel?

        let model = CompletedItemCounterModelImp(
            viewModelClosure: { viewModelLazy },
            initialCount: initialCount
        )
        let viewModel = CompletedItemCounterViewModelImp(model: model)
        view = CompletedItemCounterView(
            viewModel: viewModel,
            text: text
        )

        viewModelLazy = viewModel
        self.model = model
    }
}

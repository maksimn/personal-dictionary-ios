//
//  CounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CounterGraphImp: CounterGraph {

    let view: UIView

    private(set) weak var model: CounterModel?

    init() {
        let initialCount = MOTodoListCache.instance.completedItemCount
        let text = "Выполнено — "
        weak var viewModelLazy: CounterViewModel?

        let model = CounterModelImp(
            viewModelBlock: { viewModelLazy },
            initialCount: initialCount
        )
        let viewModel = CounterViewModelImp(model: model)
        view = CounterView(
            viewModel: viewModel,
            text: text
        )

        viewModelLazy = viewModel
        self.model = model
    }
}

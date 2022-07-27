//
//  CompletedItemVisibilityToggleBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit

final class CompletedItemVisibilityToggleBuilderImp: CompletedItemVisibilityToggleBuilder {

    func build() -> UIView {
        weak var viewModelLazy: CompletedItemVisibilityToggleViewModel?

        let model = CompletedItemVisibilityToggleModelImp(
            viewModelClosure: { viewModelLazy },
            initialState: CompletedItemVisibilityToggleState(
                isVisible: false,
                isEmpty: MOTodoListCache.instance.completedItemCount == 0
            ),
            completedItemVisibilityPublisher: CompletedItemVisibilityStreamImp.instance,
            completedItemCountSubscriber: CompletedItemCountStreamImp.instance
        )
        let viewModel = CompletedItemVisibilityToggleViewModelImp(model: model)
        let view = CompletedItemVisibilityToggleView(
            viewModel: viewModel,
            params: CompletedItemVisibilityToggleViewParams(
                show: "Показать",
                hide: "Скрыть",
                active: .systemBlue,
                disabled: .systemGray
            )
        )

        viewModelLazy = viewModel

        model.notifyWhenStateChanges()

        return view
    }
}

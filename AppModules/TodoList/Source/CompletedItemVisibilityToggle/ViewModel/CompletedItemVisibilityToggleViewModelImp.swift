//
//  CompletedItemVisibilityToggleViewModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

final class CompletedItemVisibilityToggleViewModelImp: CompletedItemVisibilityToggleViewModel {

    private let model: CompletedItemVisibilityToggleModel

    let state: BehaviorRelay<CompletedItemVisibilityToggleState>

    init(model: CompletedItemVisibilityToggleModel) {
        self.model = model
        state = BehaviorRelay<CompletedItemVisibilityToggleState>(value: model.initialState)
    }
}

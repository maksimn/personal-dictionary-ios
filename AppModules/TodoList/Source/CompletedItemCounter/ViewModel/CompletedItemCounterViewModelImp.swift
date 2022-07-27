//
//  CompletedItemCounterViewModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

final class CompletedItemCounterViewModelImp: CompletedItemCounterViewModel {

    let count: BehaviorRelay<Int>

    private let model: CompletedItemCounterModel

    init(model: CompletedItemCounterModel) {
        self.model = model
        count = BehaviorRelay<Int>(value: model.count)
    }
}

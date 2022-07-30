//
//  CounterViewModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa

final class CounterViewModelImp: CounterViewModel {

    let count: BehaviorRelay<Int>

    private let model: CounterModel

    init(model: CounterModel) {
        self.model = model
        count = BehaviorRelay<Int>(value: model.count)
    }
}

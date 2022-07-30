//
//  CounterModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class CounterModelImp: CounterModel {

    var count: Int {
        didSet {
            if viewModel == nil {
               viewModel = viewModelBlock()
            }

            viewModel?.count.accept(count)
        }
    }

    private let viewModelBlock: () -> CounterViewModel?

    private weak var viewModel: CounterViewModel?

    private let disposeBag = DisposeBag()

    init(viewModelBlock: @escaping () -> CounterViewModel?,
         initialCount: Int) {
        self.viewModelBlock = viewModelBlock
        count = initialCount
    }
}

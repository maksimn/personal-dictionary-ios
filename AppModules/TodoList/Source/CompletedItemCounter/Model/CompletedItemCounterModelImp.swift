//
//  CompletedItemCounterModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class CompletedItemCounterModelImp: CompletedItemCounterModel {

    var count: Int {
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

    init(viewModelClosure: @escaping () -> CompletedItemCounterViewModel?,
         initialCount: Int) {
        self.viewModelClosure = viewModelClosure
        count = initialCount
    }
}

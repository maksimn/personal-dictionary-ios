//
//  CompletedItemVisibilityToggleModelImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class CompletedItemVisibilityToggleModelImp: CompletedItemVisibilityToggleModel {

    private(set) var initialState: CompletedItemVisibilityToggleState

    private let viewModelClosure: () -> CompletedItemVisibilityToggleViewModel?

    private weak var viewModel: CompletedItemVisibilityToggleViewModel?

    private let disposeBag = DisposeBag()

    private let completedItemVisibilityPublisher: CompletedItemVisibilityPublisher

    init(
        viewModelClosure: @escaping () -> CompletedItemVisibilityToggleViewModel?,
        initialState: CompletedItemVisibilityToggleState,
        completedItemVisibilityPublisher: CompletedItemVisibilityPublisher,
        completedItemCountSubscriber: CompletedItemCountSubscriber
    ) {
        self.viewModelClosure = viewModelClosure
        self.initialState = initialState
        self.completedItemVisibilityPublisher = completedItemVisibilityPublisher
        completedItemVisibilityPublisher.send(isVisible: initialState.isVisible)
        completedItemCountSubscriber.count
            .subscribe(onNext: { [weak self] in self?.onNextCompletedItemCount($0) })
            .disposed(by: disposeBag)
    }

    func notifyWhenStateChanges() {
        initViewModelIfNeeded()
        viewModel?.state.subscribe(onNext: { [weak self] state in
            self?.completedItemVisibilityPublisher.send(isVisible: state.isVisible)
        }).disposed(by: disposeBag)
    }

    private func onNextCompletedItemCount(_ count: Int) {
        initViewModelIfNeeded()
        guard let state = viewModel?.state.value else { return }
        viewModel?.state.accept(
            CompletedItemVisibilityToggleState(
                isVisible: state.isVisible,
                isEmpty: count == 0
            )
        )
    }

    private func initViewModelIfNeeded() {
        if viewModel == nil {
            viewModel = viewModelClosure()
        }
    }
}

//
//  ToggableItemListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

final class ToggableItemListView: UIView {

    let itemListGraph: ItemListGraph
    let completedItemCounterGraph: CompletedItemCounterGraph

    let completedTodoVisibilityToggle = UIButton()
    let disposeBag = DisposeBag()

    private let viewModel: ToggableItemListViewModel

    init(viewModel: ToggableItemListViewModel,
         itemListBuilder: ItemListBuilder,
         completedItemCounterBuilder: CompletedItemCounterBuilder) {
        self.viewModel = viewModel
        self.itemListGraph = itemListBuilder.build()
        self.completedItemCounterGraph = completedItemCounterBuilder.build()
        super.init(frame: .zero)
        initViews()
        subscribeToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func subscribeToViewModel() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }

            self.itemListGraph.model?.items = state.areCompletedTodosVisible ?
                                              state.items :
                                              state.items.filter { !$0.isCompleted }
            self.completedItemCounterGraph.model?.count = state.completedItemCount
            self.updateCompletedTodoVisibilityToggle(state: state)
        }).disposed(by: disposeBag)
    }

    @objc
    func onCompletedTodosVisibilityButtonTap() {
        viewModel.toggleCompletedTodoVisibility()
    }

    private func updateCompletedTodoVisibilityToggle(state: ToggableItemListState) {
        completedTodoVisibilityToggle.setTitle(state.areCompletedTodosVisible ? Strings.hide : Strings.show,
                                               for: .normal)
        completedTodoVisibilityToggle.setTitleColor(state.completedItemCount == 0 ? .systemGray : .systemBlue,
                                                    for: .normal)
        completedTodoVisibilityToggle.isEnabled = state.completedItemCount > 0
    }
}

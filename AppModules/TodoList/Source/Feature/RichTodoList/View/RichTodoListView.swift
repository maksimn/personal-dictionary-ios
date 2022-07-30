//
//  RichTodoListView.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

final class RichTodoListView: UIView {

    let itemListGraph: ItemListGraph
    let counterGraph: CounterGraph

    let completedTodoVisibilityToggle = UIButton()
    let disposeBag = DisposeBag()

    private let viewModel: RichTodoListViewModel

    init(viewModel: RichTodoListViewModel,
         itemListBuilder: ItemListBuilder,
         counterBuilder: CounterBuilder) {
        self.viewModel = viewModel
        self.itemListGraph = itemListBuilder.build()
        self.counterGraph = counterBuilder.build()
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
            self.counterGraph.model?.count = state.completedItemCount
            self.updateCompletedTodoVisibilityToggle(state: state)
        }).disposed(by: disposeBag)
    }

    @objc
    func onCompletedTodosVisibilityButtonTap() {
        viewModel.toggleCompletedTodoVisibility()
    }

    private func updateCompletedTodoVisibilityToggle(state: RichTodoListState) {
        completedTodoVisibilityToggle.setTitle(state.areCompletedTodosVisible ? Strings.hide : Strings.show,
                                               for: .normal)
        completedTodoVisibilityToggle.setTitleColor(state.completedItemCount == 0 ? .systemGray : .systemBlue,
                                                    for: .normal)
        completedTodoVisibilityToggle.isEnabled = state.completedItemCount > 0
    }
}

//
//  RichTodoListViewModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

final class RichTodoListViewModelImp: RichTodoListViewModel {

    let state: BehaviorRelay<RichTodoListState>

    private let model: RichTodoListModel

    init(model: RichTodoListModel) {
        self.model = model
        state = BehaviorRelay<RichTodoListState>(value: model.state)
    }

    func toggleCompletedTodoVisibility() {
        model.toggleCompletedTodoVisibility()
    }
}

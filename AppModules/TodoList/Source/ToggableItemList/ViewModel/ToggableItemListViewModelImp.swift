//
//  ToggableItemListViewModelImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxCocoa

final class ToggableItemListViewModelImp: ToggableItemListViewModel {

    let state: BehaviorRelay<ToggableItemListState>

    private let model: ToggableItemListModel

    init(model: ToggableItemListModel) {
        self.model = model
        state = BehaviorRelay<ToggableItemListState>(value: model.state)
    }

    func toggleCompletedTodoVisibility() {
        model.toggleCompletedTodoVisibility()
    }
}

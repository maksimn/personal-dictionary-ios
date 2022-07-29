//
//  ToggableItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import RxSwift
import UIKit

final class ToggableItemListGraphImp: ToggableItemListGraph {

    let view: UIView

    private(set) weak var model: ToggableItemListModel?

    init(service: TodoListService,
         cudSubscriber: TodoItemCUDSubscriber) {
        weak var viewModelLazy: ToggableItemListViewModel?

        let model = ToggableItemListModelImp(
            initialState: ToggableItemListState(
                items: [],
                areCompletedTodosVisible: false,
                completedItemCount: 0
            ),
            service: service,
            cudSubscriber: cudSubscriber,
            viewModelBlock: { viewModelLazy }
        )
        let viewModel = ToggableItemListViewModelImp(model: model)
        view = ToggableItemListView(
            viewModel: viewModel,
            itemListBuilder: ItemListBuilderImp(delegate: model),
            completedItemCounterBuilder: CompletedItemCounterBuilderImp()
        )

        viewModelLazy = viewModel
        self.model = model
    }
}

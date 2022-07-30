//
//  RichTodoListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import RxSwift
import UIKit

final class RichTodoListGraphImp: RichTodoListGraph {

    let view: UIView

    private(set) weak var model: RichTodoListModel?

    init(service: TodoListService,
         cudSubscriber: TodoItemCUDSubscriber,
         navigationController: UINavigationController?) {
        weak var viewModelLazy: RichTodoListViewModel?

        let model = RichTodoListModelImp(
            initialState: RichTodoListState(
                items: [],
                areCompletedTodosVisible: false,
                completedItemCount: 0
            ),
            service: service,
            cudSubscriber: cudSubscriber,
            viewModelBlock: { viewModelLazy }
        )
        let viewModel = RichTodoListViewModelImp(model: model)
        view = RichTodoListView(
            viewModel: viewModel,
            itemListBuilder: ItemListBuilderImp(
                delegate: model,
                navigationController: navigationController
            ),
            counterBuilder: CounterBuilderImp()
        )

        viewModelLazy = viewModel
        self.model = model
    }
}

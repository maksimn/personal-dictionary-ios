//
//  ItemListGraphImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class ItemListGraphImp: ItemListGraph {

    weak var model: ItemListModel?

    var view: UIView

    init(delegate: ItemListDelegate?,
         itemEditorRouter: NavToItemEditorRouter) {
        weak var viewModelLazy: ItemListViewModel?

        let model = ItemListModelImp(
            delegate: delegate,
            viewModelBlock: { viewModelLazy }
        )
        let viewModel = ItemListViewModelImp(model: model)
        view = ItemListView(
            viewModel: viewModel,
            itemEditorRouter: itemEditorRouter
        )

        viewModelLazy = viewModel
        self.model = model
    }
}

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
         navToEditorRouter: NavToEditorRouter) {
        weak var viewModelLazy: ItemListViewModel?

        let model = ItemListModelImp(
            delegate: delegate,
            viewModelBlock: { viewModelLazy }
        )
        let viewModel = ItemListViewModelImp(model: model)
        view = ItemListView(
            viewModel: viewModel,
            navToEditorRouter: navToEditorRouter
        )

        viewModelLazy = viewModel
        self.model = model
    }
}
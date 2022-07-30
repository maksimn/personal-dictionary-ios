//
//  ItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class ItemListBuilderImp: ItemListBuilder {

    private weak var delegate: ItemListDelegate?
    private weak var navigationController: UINavigationController?

    init(delegate: ItemListDelegate?,
         navigationController: UINavigationController?) {
        self.delegate = delegate
        self.navigationController = navigationController
    }

    func build() -> ItemListGraph {
        ItemListGraphImp(
            delegate: delegate,
            navToEditorRouter: NavToEditorRouterImp(
                navigationController: navigationController,
                editorBuilder: EditorBuilderImpl()
            )
        )
    }
}

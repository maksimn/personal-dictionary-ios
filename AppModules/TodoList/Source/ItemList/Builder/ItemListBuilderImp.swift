//
//  ItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

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
            itemEditorRouter: NavToItemEditorRouterImp(
                navigationController: navigationController,
                todoEditorBuilder: TodoEditorBuilderImpl()
            )
        )
    }
}

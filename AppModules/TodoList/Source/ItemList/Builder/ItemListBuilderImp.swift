//
//  ItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class ItemListBuilderImp: ItemListBuilder {

    private weak var delegate: ItemListDelegate?

    init(delegate: ItemListDelegate?) {
        self.delegate = delegate
    }

    func build() -> ItemListGraph {
        ItemListGraphImp(delegate: delegate)
    }
}

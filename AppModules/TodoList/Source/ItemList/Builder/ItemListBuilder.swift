//
//  ItemListBuilder.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

protocol ItemListBuilder {

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> ItemListGraph
}

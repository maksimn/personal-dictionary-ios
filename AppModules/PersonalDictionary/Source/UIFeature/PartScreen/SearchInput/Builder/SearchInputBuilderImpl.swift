//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchInputBuilderImpl: SearchInputBuilder {

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> SearchInputGraph {
        SearchInputGraphImpl()
    }
}

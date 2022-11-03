//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import Foundation

/// Реализация билдера фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerBuilderImpl: SearchModePickerBuilder {

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
    func build() -> SearchModePickerGraph {
        let initialSearchMode: SearchMode = .bySourceWord
        let viewParams = SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("Search by:"),
            sourceWordText: bundle.moduleLocalizedString("source word"),
            translationText: bundle.moduleLocalizedString("translation")
        )

        return SearchModePickerGraphImpl(
            searchMode: initialSearchMode,
            viewParams: viewParams
        )
    }
}

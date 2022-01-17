//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация билдера фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerBuilderImpl: SearchModePickerBuilder {

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> SearchModePickerMVVM {
        let bundle = Bundle(for: type(of: self))
        let initialSearchMode: SearchMode = .bySourceWord
        let viewParams = SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("Search by:"),
            sourceWordText: bundle.moduleLocalizedString("source word"),
            translationText: bundle.moduleLocalizedString("translation")
        )

        return SearchModePickerMVVMImpl(
            searchMode: initialSearchMode,
            viewParams: viewParams
        )
    }
}

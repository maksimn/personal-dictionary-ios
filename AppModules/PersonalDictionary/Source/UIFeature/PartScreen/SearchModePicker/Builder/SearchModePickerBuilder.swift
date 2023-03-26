//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerBuilder: ViewBuilder {

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UIView {
        let viewModel = SearchModePickerViewModelImpl(
            searchModeSender: SearchModeStreamImpl.instance,
            logger: logger()
        )
        let view = SearchModePickerView(
            params: viewParams(),
            viewModel: viewModel,
            theme: Theme.data,
            logger: logger()
        )

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.SearchModePicker")
    }

    private func viewParams() -> SearchModePickerViewParams {
        SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("LS_SEARCH_BY"),
            sourceWordText: bundle.moduleLocalizedString("LS_SOURCE_WORD"),
            translationText: bundle.moduleLocalizedString("LS_TRANSLATION")
        )
    }
}

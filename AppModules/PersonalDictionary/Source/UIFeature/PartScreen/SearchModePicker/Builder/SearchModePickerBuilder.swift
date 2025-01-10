//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerBuilder: ViewBuilder {

    private let bundle: Bundle

    private let featureName = "PersonalDictionary.SearchModePicker"

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UIView {
        let searchModeStreamFactory = SearchModeStreamFactory(featureName: featureName)
        let view = SearchModePickerView(
            searchModeSender: searchModeStreamFactory.create(),
            params: viewParams(),
            theme: Theme.data,
            logger: logger()
        )

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: featureName)
    }

    private func viewParams() -> SearchModePickerViewParams {
        SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("LS_SEARCH_BY"),
            sourceWordText: bundle.moduleLocalizedString("LS_SOURCE_WORD"),
            translationText: bundle.moduleLocalizedString("LS_TRANSLATION")
        )
    }
}

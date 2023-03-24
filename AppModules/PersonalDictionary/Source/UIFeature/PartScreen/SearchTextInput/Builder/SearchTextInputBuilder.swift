//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilder: SearchControllerBuilder {

    private let bundle: Bundle

    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UISearchController {
        let placeholder = bundle.moduleLocalizedString("LS_SEARCH")
        let model = SearchTextInputModelImpl(
            searchTextStream: SearchTextStreamImpl.instance,
            logger: logger()
        )
        let view = SearchTextInputView(model: model, placeholder: placeholder, logger: logger())

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.SearchTextInput")
    }
}

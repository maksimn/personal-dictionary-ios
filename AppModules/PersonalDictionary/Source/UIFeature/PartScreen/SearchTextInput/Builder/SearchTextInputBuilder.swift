//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilder: SearchControllerBuilder {

    private let bundle: Bundle

    private let featureName = "PersonalDictionary.SearchTextInput"

    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UISearchController {
        let placeholder = bundle.moduleLocalizedString("LS_SEARCH")
        let searchTextStreamFactory = SearchTextStreamFactory(featureName: featureName)
        let view = SearchTextInputView(
            sender: searchTextStreamFactory.create(),
            placeholder: placeholder,
            logger: logger()
        )

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: featureName)
    }
}

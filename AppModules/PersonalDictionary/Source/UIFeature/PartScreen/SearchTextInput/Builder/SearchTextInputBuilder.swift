//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilder: ViewBuilder {

    private let bundle: Bundle

    /// Инициализатор.
    /// - Parameters:
    ///  - bundle: бандл приложения.
    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func build() -> UIView {
        let viewModel = SearchTextInputViewModelImpl(
            searchTextStream: SearchTextStreamImpl.instance,
            logger: logger()
        )
        let view = SearchTextInputView(
            params: viewParams(),
            viewModel: viewModel,
            logger: logger()
        )

        return view
    }

    private func logger() -> SLogger {
        SLoggerImp(category: "PersonalDictionary.SearchTextInput")
    }

    private func viewParams() -> SearchTextInputParams {
        let placeholder = bundle.moduleLocalizedString("LS_SEARCH_TEXT_PLACEHOLDER")
        let size = CGSize(width: UIScreen.main.bounds.width - 72, height: 44)

        return SearchTextInputParams(placeholder: placeholder, size: size)
    }
}

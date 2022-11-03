//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера фичи "Элемент ввода поискового текста".
final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

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
    func build() -> SearchTextInputGraph {
        let viewParams = SearchTextInputViewParams(
            placeholder: bundle.moduleLocalizedString("Enter a word for searching"),
            size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44)
        )

        return SearchTextInputGraphImpl(viewParams: viewParams)
    }
}

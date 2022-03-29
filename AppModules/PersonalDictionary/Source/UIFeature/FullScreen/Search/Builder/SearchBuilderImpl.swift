//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    private let appConfig: Config

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: зависимости фичи.
    init(appConfig: Config) {
        self.appConfig = appConfig
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        SearchViewController(
            viewParams: searchViewParams,
            searchTextInputBuilder: SearchTextInputBuilderImpl(),
            searchModePickerBuilder: SearchModePickerBuilderImpl(),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, appConfig: appConfig),
            searchEngineBuilder: SearchEngineBuilderImpl(appConfig: appConfig)
        )
    }

    private var searchViewParams: SearchViewParams {
        SearchViewParams(
            searchResultTextParams: TextLabelParams(
                textColor: Theme.instance.secondaryTextColor,
                font: Theme.instance.normalFont,
                text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
            )
        )
    }
}

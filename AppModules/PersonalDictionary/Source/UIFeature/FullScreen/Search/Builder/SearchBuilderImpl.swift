//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    private let appConfig: AppConfig

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: зависимости фичи.
    init(appConfig: AppConfig) {
        self.appConfig = appConfig
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        SearchViewController(
            viewParams: searchViewParams,
            searchTextInputBuilder: SearchTextInputBuilderImpl(bundle: appConfig.bundle),
            searchModePickerBuilder: SearchModePickerBuilderImpl(bundle: appConfig.bundle),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, appConfig: appConfig),
            searchEngineBuilder: SearchEngineBuilderImpl(appConfig: appConfig)
        )
    }

    private var searchViewParams: SearchViewParams {
        SearchViewParams(
            searchResultTextParams: TextLabelParams(
                textColor: Theme.data.secondaryTextColor,
                font: Theme.data.normalFont,
                text: appConfig.bundle.moduleLocalizedString("No words found")
            )
        )
    }
}

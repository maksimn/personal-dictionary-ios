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
            searchViewParams: createSearchViewParams(),
            searchTextInputBuilder: SearchTextInputBuilderImpl(),
            searchEngineBuilder: SearchEngineBuilderImpl(
                searchableWordList: WordListRepositoryGraphImpl(appConfig: appConfig).repository
            ),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, appConfig: appConfig),
            searchModePickerBuilder: SearchModePickerBuilderImpl()
        )
    }

    private func createSearchViewParams() -> SearchViewParams {
        SearchViewParams(
            emptySearchResultTextParams: TextLabelParams(
                textColor: .darkGray,
                font: Theme.standard.normalFont,
                text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
            )
        )
    }
}

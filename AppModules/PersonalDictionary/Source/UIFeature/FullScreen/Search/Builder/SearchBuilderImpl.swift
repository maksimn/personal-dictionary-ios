//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    let appConfig: Config

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfig: конфигурация приложения.
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
            searchEngineBuilder: SearchEngineBuilderImpl(wordListFetcher: wordListRepository),
            wordListBuilder: WordListBuilderImpl(
                params: WordListParams(shouldAnimateWhenAppear: false),
                dependency: self
            ),
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

    private var wordListRepository: WordListRepository {
        WordListRepositoryGraphImpl(appConfig: appConfig).repository
    }
}

/// Для передачи внешних зависимостей во вложенную фичу "Список слов".
extension SearchBuilderImpl: WordListDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

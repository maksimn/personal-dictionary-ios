//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Зависимости фичи "Поиск по словам в словаре".
protocol SearchDependency {

    var appConfig: Config { get }

    var wordListRepositoryGraph: WordListRepositoryGraph { get }
}

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    let appConfig: Config

    let wordListRepositoryGraph: WordListRepositoryGraph

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: SearchDependency) {
        appConfig = dependency.appConfig
        wordListRepositoryGraph = dependency.wordListRepositoryGraph
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        SearchViewController(
            searchViewParams: createSearchViewParams(),
            searchTextInputBuilder: SearchTextInputBuilderImpl(),
            searchEngineBuilder: SearchEngineBuilderImpl(searchableWordList: wordListRepositoryGraph.repository),
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
}

/// Для передачи внешних зависимостей во вложенную фичу "Список слов".
extension SearchBuilderImpl: WordListDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepositoryGraph.repository
    }
}

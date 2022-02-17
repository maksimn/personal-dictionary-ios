//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Внешние зависимости фичи "Поиска".
protocol SearchExternals {

    var appConfig: AppConfigs { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    let appConfig: AppConfigs

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: SearchExternals) {
        appConfig = externals.appConfig
        logger = externals.logger
        wordListRepository = externals.wordListRepository
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
                externals: self
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
extension SearchBuilderImpl: WordListExternals {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

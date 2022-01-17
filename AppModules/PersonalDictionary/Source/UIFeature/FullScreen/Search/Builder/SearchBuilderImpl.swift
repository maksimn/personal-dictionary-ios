//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    private let appViewConfigs: AppViewConfigs
    private let wordListFetcher: WordListFetcher
    private let wordListBuilder: WordListBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: параметры конфигурации приложения.
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    init(appViewConfigs: AppViewConfigs,
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder) {
        self.appViewConfigs = appViewConfigs
        self.wordListFetcher = wordListFetcher
        self.wordListBuilder = wordListBuilder
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///   View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        let dependencies = SearchDependencies(wordListFetcher: wordListFetcher)

        return SearchViewController(appViewConfigs: appViewConfigs,
                                    searchTextInputBuilder: dependencies.searchTextInputBuilder,
                                    searchEngineBuilder: dependencies.searchEngineBuilder,
                                    wordListBuilder: wordListBuilder,
                                    searchModePickerBuilder: dependencies.searchModePickerBuilder,
                                    searchResultTextLabelParams: dependencies.searchResultTextLabelParams)
    }
}

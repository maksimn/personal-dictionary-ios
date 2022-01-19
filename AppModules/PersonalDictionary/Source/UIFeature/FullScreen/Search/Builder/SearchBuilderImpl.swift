//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    private let wordListConfigs: WordListConfigs
    private let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListConfigs: параметры конфигурации списка слов.
    ///  - wordListRepository: хранилище списка слов.
    init(wordListConfigs: WordListConfigs,
         wordListRepository: WordListRepository) {
        self.wordListConfigs = wordListConfigs
        self.wordListRepository = wordListRepository
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///   View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        let dependencies = SearchDependencies(wordListConfigs: wordListConfigs, wordListRepository: wordListRepository)

        return SearchViewController(searchViewParams: dependencies.searchViewParams,
                                    searchTextInputBuilder: dependencies.searchTextInputBuilder,
                                    searchEngineBuilder: dependencies.searchEngineBuilder,
                                    wordListBuilder: dependencies.createWordListBuilder(),
                                    searchModePickerBuilder: dependencies.searchModePickerBuilder)
    }
}

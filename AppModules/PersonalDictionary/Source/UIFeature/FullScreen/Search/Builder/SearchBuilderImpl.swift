//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Внешние зависимости фичи "Поиска".
protocol SearchExternals: WordListExternals {

    /// Источник данных для списка слов из хранилища личного словаря.
    var wordListFetcher: WordListFetcher { get }
}

/// Билдер Фичи "Поиск по словам в словаре".
final class SearchBuilderImpl: SearchBuilder {

    private let externals: SearchExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: SearchExternals) {
        self.externals = externals
    }

    /// Создать экран Поиска.
    /// - Returns:
    ///  - View controller экрана поиска по словам в словаре.
    func build() -> UIViewController {
        let dependencies = SearchDependencies(externals: externals)

        return SearchViewController(searchViewParams: dependencies.searchViewParams,
                                    searchTextInputBuilder: dependencies.searchTextInputBuilder,
                                    searchEngineBuilder: dependencies.searchEngineBuilder,
                                    wordListBuilder: dependencies.wordListBuilder,
                                    searchModePickerBuilder: dependencies.searchModePickerBuilder)
    }
}

//
//  SearchDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

/// Зависимости Фичи "Поиск по словам в словаре".
final class SearchDependencies {

    /// Билдер вложенной фичи "Элемент ввода текста для поиска"
    let searchTextInputBuilder = SearchTextInputBuilderImpl()

    /// Билдер вложенной фичи "Выбор режима поиска"
    let searchModePickerBuilder = SearchModePickerBuilderImpl()

    /// Билдер фичи "Список слов".
    private(set) lazy var wordListBuilder = WordListBuilderImpl(
        params: WordListParams(shouldAnimateWhenAppear: false),
        externals: externals
    )

    /// Билдер вложенной фичи "Поисковый Движок"
    private(set) lazy var searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: externals.wordListFetcher)

    /// Параметры представления Поиска
    private(set) lazy var searchViewParams = SearchViewParams(
        appViewConfigs: externals.appConfig.appViewConfigs,
        emptySearchResultTextParams: TextLabelParams(
            textColor: .darkGray,
            font: UIFont.systemFont(ofSize: 17),
            text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
        )
    )

    private let externals: SearchExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: SearchExternals) {
        self.externals = externals
    }
}

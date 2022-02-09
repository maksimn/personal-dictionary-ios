//
//  SearchDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
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
        externals: self
    )

    /// Билдер вложенной фичи "Поисковый Движок"
    private(set) lazy var searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: externals.wordListRepository)

    /// Параметры представления Поиска
    private(set) lazy var searchViewParams = SearchViewParams(
        theme: Theme.data,
        emptySearchResultTextParams: TextLabelParams(
            textColor: .darkGray,
            font: UIFont.systemFont(ofSize: 17),
            text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
        )
    )

    fileprivate let externals: SearchExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: SearchExternals) {
        self.externals = externals
    }
}

/// Для передачи внешних зависимостей во вложенную фичу "Список слов".
extension SearchDependencies: WordListExternals {

    var appConfig: AppConfigs {
        externals.appConfig
    }

    var cudOperations: WordItemCUDOperations {
        externals.wordListRepository
    }

    var logger: Logger {
        externals.logger
    }
}

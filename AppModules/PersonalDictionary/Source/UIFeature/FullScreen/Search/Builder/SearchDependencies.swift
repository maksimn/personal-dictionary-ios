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

    /// Билдер вложенной фичи "Поисковый Движок"
    private(set) lazy var searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListRepository)

    /// Параметры представления Поиска
    private(set) lazy var searchViewParams = SearchViewParams(
        appViewConfigs: wordListConfigs.appConfigs.appViewConfigs,
        emptySearchResultTextParams: TextLabelParams(
            textColor: .darkGray,
            font: UIFont.systemFont(ofSize: 17),
            text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
        )
    )

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

    /// Создать билдер фичи "Список слов".
    /// - Returns:
    ///  -  билдер фичи "Список слов".
    func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(configs: wordListConfigs,
                            cudOperations: wordListRepository)
    }
}

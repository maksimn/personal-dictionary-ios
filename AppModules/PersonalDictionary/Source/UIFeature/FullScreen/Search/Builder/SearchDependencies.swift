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
    let searchEngineBuilder: SearchEngineBuilder

    /// Параметры надписи с результатом поиска (показывается, когда по запросу не найдено ни одного слова)
    private(set) lazy var searchResultTextLabelParams = TextLabelParams(
        textColor: .darkGray,
        font: UIFont.systemFont(ofSize: 17),
        text: Bundle(for: type(of: self)).moduleLocalizedString("No words found")
    )

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    init(wordListFetcher: WordListFetcher) {
        searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListFetcher)
    }
}

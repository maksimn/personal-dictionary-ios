//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера Фичи "Поисковый движок".
final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let wordListFetcher: WordListFetcher

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListFetcher: протокол для получения списка слов для поиска среди них.
    init(wordListFetcher: WordListFetcher) {
        self.wordListFetcher = wordListFetcher
    }

    /// Создать объект поискового движка.
    /// - Returns: объект поискового движка.
    func build() -> SearchEngine {
        SearchEngineImpl(wordListFetcher: wordListFetcher)
    }
}

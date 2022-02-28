//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация билдера Фичи "Поисковый движок".
final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let searchableWordList: SearchableWordList

    /// Инициализатор.
    /// - Parameters:
    ///  - searchableWordList: протокол для поиска в списке слов.
    init(searchableWordList: SearchableWordList) {
        self.searchableWordList = searchableWordList
    }

    /// Создать объект поискового движка.
    /// - Returns: объект поискового движка.
    func build() -> SearchEngine {
        SearchEngineImpl(searchableWordList: searchableWordList)
    }
}

//
//  SearchEngineImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

/// Реализация поискового движка.
final class SearchEngineImpl: SearchEngine {

    private let searchableWordList: SearchableWordList

    /// Инициализатор.
    /// - Parameters:
    ///  - searchableWordList: протокол для поиска в списке слов.
    init(searchableWordList: SearchableWordList) {
        self.searchableWordList = searchableWordList
    }

    /// Найти слова, соответствующие параметрам поиска.
    /// - Parameters:
    ///  - string: строка для поиска.
    ///  - mode: режим поиска.
    /// - Returns: данные с результатом поиска.
    func findWords(contain string: String, mode: SearchMode) -> Single<SearchResultData> {
        Single<SearchResultData>.create { [weak self] observer in
            let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            if string == "" {
                observer(.success(SearchResultData(searchState: .initial, foundWordList: [])))
                return Disposables.create { }
            }

            let filteredWordList = mode == .bySourceWord ?
                                   self?.searchableWordList.findWords(contain: string) :
                                   self?.searchableWordList.findWords(whereTranslationContains: string)

            observer(.success(SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList ?? [])))
            return Disposables.create { }
        }
    }
}

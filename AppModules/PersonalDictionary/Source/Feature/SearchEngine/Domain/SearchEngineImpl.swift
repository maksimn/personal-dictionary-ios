//
//  SearchEngineImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

/// Реализация поискового движка.
final class SearchEngineImpl: SearchEngine {

    private let wordListFetcher: WordListFetcher

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListFetcher: протокол для получения списка слов для поиска среди них.
    init(wordListFetcher: WordListFetcher) {
        self.wordListFetcher = wordListFetcher
    }

    /// Найти слова, соответствующие параметрам поиска.
    /// - Parameters:
    ///  - string: строка для поиска.
    ///  - mode: режим поиска.
    /// - Returns: данные с результатом поиска.
    func findWords(contain string: String, mode: SearchMode) -> Single<SearchResultData> {
        Single<SearchResultData>.create { observer in
            let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            if string == "" {
                observer(.success(SearchResultData(searchState: .initial, foundWordList: [])))
                return Disposables.create { }
            }

            let filteredWordList = self.wordListFetcher.wordList.filter { item in
                (mode == .bySourceWord ? item.text : (item.translation ?? ""))
                    .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                    .contains(string)
            }

            observer(.success(SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList)))
            return Disposables.create { }
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .observeOn(MainScheduler.instance)
    }
}

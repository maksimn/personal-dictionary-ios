//
//  SearchEngineImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift

final class SearchEngineImpl: SearchEngine {

    private let wordListFetcher: WordListFetcher

    init(wordListFetcher: WordListFetcher) {
        self.wordListFetcher = wordListFetcher
    }

    func findItems(contain string: String, mode: SearchMode) -> Single<SearchResultData> {
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
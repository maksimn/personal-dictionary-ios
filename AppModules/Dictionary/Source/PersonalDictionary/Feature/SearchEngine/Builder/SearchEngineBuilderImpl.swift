//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let wordListFetcher: WordListFetcher

    init(wordListFetcher: WordListFetcher) {
        self.wordListFetcher = wordListFetcher
    }

    func build() -> SearchEngine {
        SearchEngineImpl(wordListFetcher: wordListFetcher)
    }
}

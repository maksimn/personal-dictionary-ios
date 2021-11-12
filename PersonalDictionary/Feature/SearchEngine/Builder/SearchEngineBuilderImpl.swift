//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchEngineBuilderImpl: SearchEngineBuilder {

    private let wordListRepository: WordListRepository

    init(wordListRepository: WordListRepository) {
        self.wordListRepository = wordListRepository
    }

    func build() -> SearchEngine {
        SearchEngineImpl(wordListRepository: wordListRepository)
    }
}

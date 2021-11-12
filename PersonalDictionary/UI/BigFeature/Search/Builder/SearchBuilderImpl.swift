//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    private let notificationCenter: NotificationCenter
    private let wordListRepository: WordListRepository
    private let wordListBuilder: WordListBuilder

    init(notificationCenter: NotificationCenter,
         wordListRepository: WordListRepository,
         wordListBuilder: WordListBuilder) {
        self.notificationCenter = notificationCenter
        self.wordListRepository = wordListRepository
        self.wordListBuilder = wordListBuilder
    }

    func build() -> SearchGraph {
        SearchGraphImpl(searchTextInputBuilder: SearchTextInputBuilderImpl(notificationCenter: notificationCenter),
                        searchEngineBuilder: SearchEngineBuilderImpl(wordListRepository: wordListRepository),
                        wordListBuilder: wordListBuilder)
    }
}

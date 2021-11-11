//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    private let globalSettings: PDGlobalSettings
    private let wordListRepository: WordListRepository
    private let translationService: TranslationService
    private let notificationCenter: NotificationCenter

    init(globalSettings: PDGlobalSettings,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.globalSettings = globalSettings
        self.wordListRepository = wordListRepository
        self.translationService = translationService
        self.notificationCenter = notificationCenter
    }

    func build() -> WordListMVVM {
        SearchWordMVVMImpl(globalSettings: globalSettings,
                           wordListRepository: wordListRepository,
                           translationService: translationService,
                           notificationCenter: notificationCenter)
    }
}

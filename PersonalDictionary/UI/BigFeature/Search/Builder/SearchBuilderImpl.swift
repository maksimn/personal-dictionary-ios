//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    private let globalViewSettings: GlobalViewSettings
    private let wordListRepository: WordListRepository
    private let translationService: TranslationService
    private let notificationCenter: NotificationCenter

    init(globalViewSettings: GlobalViewSettings,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.globalViewSettings = globalViewSettings
        self.wordListRepository = wordListRepository
        self.translationService = translationService
        self.notificationCenter = notificationCenter
    }

    func build() -> WordListMVVM {
        SearchWordMVVMImpl(globalViewSettings: globalViewSettings,
                           wordListRepository: wordListRepository,
                           translationService: translationService,
                           notificationCenter: notificationCenter)
    }
}

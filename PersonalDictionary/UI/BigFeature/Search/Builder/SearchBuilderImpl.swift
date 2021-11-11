//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    private let appViewConfigs: AppViewConfigs
    private let wordListRepository: WordListRepository
    private let translationService: TranslationService
    private let notificationCenter: NotificationCenter

    init(appViewConfigs: AppViewConfigs,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.appViewConfigs = appViewConfigs
        self.wordListRepository = wordListRepository
        self.translationService = translationService
        self.notificationCenter = notificationCenter
    }

    func build() -> WordListMVVM {
        SearchWordMVVMImpl(appViewConfigs: appViewConfigs,
                           wordListRepository: wordListRepository,
                           translationService: translationService,
                           notificationCenter: notificationCenter)
    }
}

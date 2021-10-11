//
//  SearchWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import Foundation

final class SearchWordModelImpl: WordListModel, SearchWordModel {

    weak var viewModel: WordListViewModel?

    let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func fetchWordList() {
    }

    func requestTranslationsIfNeeded() {
    }

    func removeFromRepository(_ wordItem: WordItem) {
    }
}

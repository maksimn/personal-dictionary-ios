//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

final class WordListModelImpl: WordListModel {

    weak var viewModel: WordListViewModel?

    let wordListRepository: WordListRepository
    let notificationCenter: NotificationCenter

    init(wordListRepository: WordListRepository,
         notificationCenter: NotificationCenter) {
        self.wordListRepository = wordListRepository
        self.notificationCenter = notificationCenter

        addObservers()
    }

    func fetchWordList() {
        viewModel?.wordList = wordListRepository.wordList
    }

    func add(_ wordItem: WordItem) {
        viewModel?.add(wordItem)
        wordListRepository.add(wordItem, completion: nil)
    }

    func removeFromRepository(_ wordItem: WordItem) {
        wordListRepository.remove(with: wordItem.id, completion: nil)
    }
}

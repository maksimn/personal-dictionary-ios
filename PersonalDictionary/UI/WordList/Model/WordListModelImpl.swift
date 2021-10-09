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
    let translationService: TranslationService

    init(wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.wordListRepository = wordListRepository
        self.translationService = translationService
        self.notificationCenter = notificationCenter

        addObservers()
    }

    func fetchWordList() {
        viewModel?.wordList = wordListRepository.wordList
    }

    func add(_ wordItem: WordItem) {
        viewModel?.add(wordItem)
        wordListRepository.add(wordItem, completion: nil)
        print("req start")
        translationService.fetchTranslation(for: wordItem, { result in
            switch result {
            case .success(let translationData):
                print("req success")
                print(translationData.code)
                print(translationData.text ?? "")
                print(translationData.message ?? "")
            case .failure(let error):
                print("req error")
                print(error)
            }
        })
    }

    func removeFromRepository(_ wordItem: WordItem) {
        wordListRepository.remove(with: wordItem.id, completion: nil)
    }
}

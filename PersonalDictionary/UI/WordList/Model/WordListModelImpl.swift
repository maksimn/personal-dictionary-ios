//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

class WordListModelImpl: WordListModel {

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
        guard let position = viewModel?.wordList.count else { return }

        viewModel?.add(wordItem)
        wordListRepository.add(wordItem, completion: nil)
        requestTranslation(for: wordItem, position)
    }

    func remove(wordItem: WordItem) {
        guard let position = viewModel?.wordList.firstIndex(where: { $0.id == wordItem.id }) else { return }

        viewModel?.remove(wordItem, position)
    }

    func removeFromRepository(_ wordItem: WordItem) {
        wordListRepository.remove(with: wordItem.id, completion: nil)
    }

    func requestTranslationsIfNeeded() {
        guard let wordList = viewModel?.wordList else { return }

        for position in 0..<wordList.count where wordList[position].translation == nil {
            requestTranslation(for: wordList[position], position)
        }
    }

    private func requestTranslation(for wordItem: WordItem, _ position: Int) {
        translationService.fetchTranslation(for: wordItem, { [weak self] result in
            switch result {
            case .success(let translation):
                let updatedWordItem = wordItem.update(translation: translation)

                self?.wordListRepository.update(updatedWordItem, completion: nil)
                self?.viewModel?.update(updatedWordItem, position)
            case .failure:
                break
            }
        })
    }
}

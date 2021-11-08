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

    var data: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            viewModel?.wordListData = data
        }
    }

    init(wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.wordListRepository = wordListRepository
        self.translationService = translationService
        self.notificationCenter = notificationCenter
        addObservers()
    }

    func remove(_ wordItem: WordItem, at position: Int) {
        var wordList = data.wordList

        wordList.remove(at: position)
        data = WordListData(wordList: wordList, changedItemPosition: position)
        wordListRepository.remove(with: wordItem.id, completion: nil)
    }

    func requestTranslationsIfNeeded() {
        for position in 0..<data.wordList.count where data.wordList[position].translation == nil {
            requestTranslation(for: data.wordList[position], position)
        }
    }

    // MARK: - Events

    func addNewWord(_ wordItem: WordItem) {
        var wordList = data.wordList

        wordList.insert(wordItem, at: 0)
        data = WordListData(wordList: wordList, changedItemPosition: 0)
        wordListRepository.add(wordItem, completion: nil)
        requestTranslation(for: wordItem, data.wordList.count - 1)
    }

    func remove(wordItem: WordItem) {
        if let position = data.wordList.firstIndex(where: { $0.id == wordItem.id }) {
            remove(wordItem, at: position)
        }
    }

    // MARK: - Private

    private func requestTranslation(for wordItem: WordItem, _ position: Int) {
        translationService.fetchTranslation(for: wordItem, { [weak self] result in
            switch result {
            case .success(let translation):
                self?.update(wordItem: wordItem, with: translation, at: position)
            case .failure:
                break
            }
        })
    }

    private func update(wordItem: WordItem, with translation: String, at position: Int) {
        let updatedWordItem = wordItem.update(translation: translation)
        var wordList = data.wordList

        guard position > -1 && position < wordList.count else { return }

        wordList[position] = updatedWordItem
        wordListRepository.update(updatedWordItem, completion: nil)
        data = WordListData(wordList: wordList, changedItemPosition: position)
    }
}

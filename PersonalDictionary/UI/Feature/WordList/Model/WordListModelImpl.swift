//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

final class WordListModelImpl: WordListModel {

    weak var viewModel: WordListViewModel?

    let cudOperations: WordItemCUDOperations
    let notificationCenter: NotificationCenter
    let translationService: TranslationService

    var data: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            viewModel?.wordListData = data
        }
    }

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         notificationCenter: NotificationCenter) {
        self.cudOperations = cudOperations
        self.translationService = translationService
        self.notificationCenter = notificationCenter
        addObservers()
    }

    func remove(_ wordItem: WordItem, at position: Int) {
        var wordList = data.wordList

        wordList.remove(at: position)
        data = WordListData(wordList: wordList, changedItemPosition: position)
        cudOperations.remove(with: wordItem.id, completion: nil)
        notificationCenter.post(name: .removeWord, object: nil, userInfo: [Notification.Name.removeWord: wordItem])
    }

    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        guard endPosition > startPosition,
              startPosition > -1 else {
            return
        }
        let endPosition = min(data.wordList.count, endPosition)

        for position in startPosition..<endPosition where data.wordList[position].translation == nil {
            requestTranslation(for: data.wordList[position], position)
        }
    }

    // MARK: - Events

    func addNewWord(_ wordItem: WordItem) {
        let newWordPosition = 0
        var wordList = data.wordList

        wordList.insert(wordItem, at: newWordPosition)
        data = WordListData(wordList: wordList, changedItemPosition: newWordPosition)
        cudOperations.add(wordItem, completion: nil)
        requestTranslation(for: wordItem, newWordPosition)
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
        cudOperations.update(updatedWordItem, completion: nil)
        data = WordListData(wordList: wordList, changedItemPosition: position)
    }
}

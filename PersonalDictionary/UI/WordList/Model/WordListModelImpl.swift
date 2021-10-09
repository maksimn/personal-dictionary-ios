//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

final class WordListModelImpl<TService: TranslationService>: WordListModel
    where TService.Success == [PonsResponseData] {

    weak var viewModel: WordListViewModel?

    let wordListRepository: WordListRepository
    let notificationCenter: NotificationCenter
    let translationService: TService

    init(wordListRepository: WordListRepository,
         translationService: TService,
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
        print("req start")
        translationService.fetchTranslation(for: wordItem, { [weak self] result in
            switch result {
            case .success(let dataArray):
                print("req success")
                if let translation = dataArray.first?.translation {
                    print(translation)
                    let updatedWordItem = wordItem.update(translation: translation)

                    self?.wordListRepository.update(updatedWordItem, completion: nil)
                    self?.viewModel?.update(updatedWordItem, position)
                } else {
                    print("no translation")
                }
            case .failure(let error):
                print("req error")
                print(error)
            }
        })
    }

    func removeFromRepository(_ wordItem: WordItem) {
        wordListRepository.remove(with: wordItem.id, completion: nil)
    }

    func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(onAddNewWordItem), name: .addNewWord, object: nil)
    }

    @objc
    func onAddNewWordItem(_ notification: Notification) {
        if let wordItem = notification.userInfo?[Notification.Name.addNewWord] as? WordItem {
            add(wordItem)
        }
    }
}

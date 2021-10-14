//
//  SearchWordModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import Foundation

final class SearchWordModelImpl: WordListModelImpl, SearchWordModel {

    var viewModelOne: SearchWordViewModel? {
        viewModel as? SearchWordViewModel
    }

    private var allWordList: [WordItem] = []

    func prepareForSearching() {
        allWordList = wordListRepository.wordList
    }

    func searchWord(contains string: String) {
        guard let searchMode = viewModelOne?.searchMode else { return }
        let string = string.lowercased()

        DispatchQueue.global(qos: .default).async { [weak self] in
            let searchedWordList = self?.allWordList.filter { item in
                (searchMode == .bySourceWord ? item.text : (item.translation ?? ""))
                    .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                    .contains(string)
            } ?? []

            DispatchQueue.main.async { [weak self] in
                self?.viewModelOne?.wordList = searchedWordList
                self?.viewModelOne?.isWordsNotFoundLabelHidden = searchedWordList.count > 0
            }
        }
    }

    func sendRemoveWordEvent(_ wordItem: WordItem) {
        notificationCenter.post(name: .removeWord, object: nil, userInfo: [Notification.Name.removeWord: wordItem])
    }

    override func addObservers() { }
}

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
        let searchedWordList = allWordList.filter { $0.text.lowercased().contains(string.lowercased()) }

        viewModelOne?.wordList = searchedWordList
        viewModelOne?.isMessageLabelHidden = searchedWordList.count > 0
    }
}

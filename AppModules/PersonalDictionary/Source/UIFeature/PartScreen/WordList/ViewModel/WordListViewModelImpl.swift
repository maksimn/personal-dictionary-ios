//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class WordListViewModelImpl: WordListViewModel {

    private weak var view: WordListView?
    private let model: WordListModel

    init(model: WordListModel, view: WordListView) {
        self.model = model
        self.view = view
    }

    var wordListData: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            view?.set(wordListData)
        }
    }

    func remove(_ wordItem: WordItem, at position: Int) {
        model.remove(wordItem, at: position)
    }

    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        model.requestTranslationsIfNeededWithin(startPosition: startPosition, endPosition: endPosition)
    }

    func sendRemovedWordItem(_ wordItem: WordItem) {
        model.sendRemovedWordItem(wordItem)
    }
}
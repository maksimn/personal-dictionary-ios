//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

class WordListViewModelImpl: WordListViewModel {

    unowned let view: WordListView
    let model: WordListModel

    init(model: WordListModel, view: WordListView) {
        self.model = model
        self.view = view
    }

    var wordListData: WordListData = WordListData(wordList: [], changedItemPosition: nil) {
        didSet {
            view.set(wordListData)
        }
    }

    func fetchData() {
        model.fetchData()
    }

    func remove(_ wordItem: WordItem, at position: Int) {
        model.remove(wordItem, at: position)
    }
}

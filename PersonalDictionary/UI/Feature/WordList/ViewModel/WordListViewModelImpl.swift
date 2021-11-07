//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

class WordListViewModelImpl: WordListViewModel {

    unowned let view: WordListView
    let model: WordListModel
    private var router: Router?

    private var previousWordCount = -1
    private var removedItemPosition = -1
    private var updatedItemPosition = -1

    init(model: WordListModel, view: WordListView, router: Router? = nil) {
        self.model = model
        self.view = view
        self.router = router
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

    func navigateToNewWord() {
        router?.navigateToNewWord()
    }

    func navigateToSearch() {
        router?.navigateToSearch()
    }
}

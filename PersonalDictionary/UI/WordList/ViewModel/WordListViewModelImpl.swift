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

    func fetchDataFromModel() {
        model.fetchWordList()
        model.requestTranslationsIfNeeded()
    }

    func add(_ wordItem: WordItem) {
        wordList.append(wordItem)
    }

    func update(_ wordItem: WordItem, _ position: Int) {
        updatedItemPosition = position
        wordList[position] = wordItem
    }

    func remove(_ wordItem: WordItem, _ position: Int) {
        removedItemPosition = position
        wordList.remove(at: position)
        model.removeFromRepository(wordItem)
    }

    func navigateToNewWord() {
        router?.navigateToNewWord()
    }

    func navigateToSearch() {
        router?.navigateToSearch()
    }

    var wordList: [WordItem] = [] {
        willSet {
            previousWordCount = wordList.count
        }
        didSet {
            view.set(wordList: self.wordList)

            if wordList.count == previousWordCount - 1 {
                view.removeRowAt(removedItemPosition)
            } else if wordList.count == previousWordCount {
                view.updateRowAt(updatedItemPosition)
            } else if wordList.count == previousWordCount + 1 {
                view.addNewRowToList()
            } else {
                view.reloadList()
            }
        }
    }
}

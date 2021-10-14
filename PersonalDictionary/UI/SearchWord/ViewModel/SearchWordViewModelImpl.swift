//
//  SearchWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

final class SearchWordViewModelImpl: WordListViewModelImpl, SearchWordViewModel {

    init(model: SearchWordModel, view: SearchWordView, router: Router? = nil) {
        super.init(model: model, view: view, router: router)
    }

    private var viewOne: SearchWordView? {
        view as? SearchWordView
    }

    private var modelOne: SearchWordModel? {
        model as? SearchWordModel
    }

    override var wordList: [WordItem] {
        didSet {
            viewOne?.set(wordList: self.wordList)
            viewOne?.reloadList()
        }
    }

    var searchText: String = "" {
        didSet {
            performSearch()
        }
    }

    var isWordsNotFoundLabelHidden: Bool = true {
        didSet {
            viewOne?.setWordsNotFoundLabel(hidden: isWordsNotFoundLabelHidden)
        }
    }

    var searchMode: SearchWordMode = .bySourceWord {
        didSet {
            viewOne?.set(searchMode)
            performSearch()
        }
    }

    override func fetchDataFromModel() { }

    override func remove(_ wordItem: WordItem, _ position: Int) {
        modelOne?.sendRemoveWordEvent(wordItem)
        super.remove(wordItem, position)
    }

    func prepareForSearching() {
        modelOne?.prepareForSearching()
    }

    private func performSearch() {
        if searchText.count > 0 {
            modelOne?.searchWord(contains: searchText)
        } else {
            wordList = []
            isWordsNotFoundLabelHidden = true
        }
    }
}

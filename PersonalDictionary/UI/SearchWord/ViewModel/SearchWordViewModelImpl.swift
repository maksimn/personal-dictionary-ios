//
//  SearchWordViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

final class SearchWordViewModelImpl: WordListViewModelImpl, SearchWordViewModel {

    init(model: SearchWordModel, view: SearchWordView) {
        super.init(model: model, view: view)
    }

    private var viewOne: SearchWordView? {
        view as? SearchWordView
    }

    private var modelOne: SearchWordModel? {
        model as? SearchWordModel
    }

    var searchText: String = "" {
        didSet {
            performSearch()
        }
    }

    var nothingWasFoundLabelHidden: Bool = true {
        didSet {
            viewOne?.setNothingWasFoundLabel(hidden: nothingWasFoundLabelHidden)
        }
    }

    var searchMode: SearchWordMode = .bySourceWord {
        didSet {
            viewOne?.set(searchMode)
            performSearch()
        }
    }

    override func remove(_ wordItem: WordItem, at position: Int) {
        modelOne?.sendRemoveWordEvent(wordItem)
        super.remove(wordItem, at: position)
    }

    func prepareForSearching() {
        modelOne?.prepareForSearching()
    }

    private func performSearch() {
        if searchText.count > 0 {
            modelOne?.searchWord(contains: searchText)
        } else {
            wordListData = WordListData(wordList: [], changedItemPosition: nil)
            nothingWasFoundLabelHidden = true
        }
    }
}

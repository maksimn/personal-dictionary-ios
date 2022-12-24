//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class SearchWordListModelImpl: SearchWordListModel, SearchInputListener {

    private let viewModelBlock: () -> SearchWordListViewModel?
    private weak var viewModel: SearchWordListViewModel?

    private let searchableWordList: SearchableWordList

    init(viewModelBlock: @escaping () -> SearchWordListViewModel?,
         searchableWordList: SearchableWordList) {
        self.viewModelBlock = viewModelBlock
        self.searchableWordList = searchableWordList
    }

    func onSeachInputChanged(_ data: SearchInputData) {
        performSearch(for: data.text, mode: data.mode)
    }

    private func performSearch(for searchText: String, mode: SearchMode) {
        let string = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        initViewModelIfNeeded()

        if string.isEmpty {
            viewModel?.searchResult.accept(SearchResultData(searchState: .initial, foundWordList: []))
            return
        }

        let filteredWordList = mode == .bySourceWord ?
            searchableWordList.findWords(contain: string) :
            searchableWordList.findWords(whereTranslationContains: string)

        viewModel?.searchResult.accept(SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList))
    }

    private func initViewModelIfNeeded() {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }
    }
}

//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class SearchWordListModelImpl: Model {

    private let viewModelBlock: () -> SearchWordListViewModel?
    private weak var viewModel: SearchWordListViewModel?
    private let searchableWordList: SearchableWordList
    private let disposeBag = DisposeBag()

    init(
        viewModelBlock: @escaping () -> SearchWordListViewModel?,
        searchableWordList: SearchableWordList,
        searchTextStream: SearchTextStream,
        searchModeStream: SearchModeStream
    ) {
        self.viewModelBlock = viewModelBlock
        self.searchableWordList = searchableWordList
        Observable.combineLatest(searchTextStream.searchText, searchModeStream.searchMode)
            .subscribe(onNext: { [weak self] (searchText, searchMode) in
                self?.performSearch(for: searchText, mode: searchMode)
            }).disposed(by: disposeBag)
    }

    private func performSearch(for searchText: String, mode: SearchMode) {
        let string = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if viewModel == nil {
            viewModel = viewModelBlock()
        }

        if string.isEmpty {
            viewModel?.searchResult.accept(SearchResultData(searchState: .initial, foundWordList: []))
            return
        }

        let filteredWordList = mode == .bySourceWord ?
            searchableWordList.findWords(contain: string) :
            searchableWordList.findWords(whereTranslationContains: string)

        viewModel?.searchResult.accept(SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList))
    }
}

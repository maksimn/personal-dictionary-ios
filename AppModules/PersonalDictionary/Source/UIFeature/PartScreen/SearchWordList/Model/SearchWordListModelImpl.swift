//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class SearchWordListModelImpl: SearchWordListModel {

    private let viewModelBlock: () -> SearchWordListViewModel?
    private weak var viewModel: SearchWordListViewModel?

    private let searchEngine: SearchEngine

    private let disposeBag = DisposeBag()

    init(viewModelBlock: @escaping () -> SearchWordListViewModel?,
         searchEngine: SearchEngine) {
        self.viewModelBlock = viewModelBlock
        self.searchEngine = searchEngine
    }

    func performSearch(for searchText: String, mode: SearchMode) {
        searchEngine.findWords(contain: searchText, mode: mode)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?.initViewModelIfNeeded()
                    self?.viewModel?.searchResult.accept(data)
                }
            )
            .disposed(by: disposeBag)
    }

    private func initViewModelIfNeeded() {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }
    }
}

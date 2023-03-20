//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class SearchViewModelImpl: SearchViewModel {

    let searchResult: BindableSearchResult

    private let model: SearchModel
    private let disposeBag = DisposeBag()

    init(initialData: SearchResultData,
         model: SearchModel,
         searchTextStream: SearchTextStream,
         searchModeStream: SearchModeStream) {
        searchResult = BindableSearchResult(value: initialData)
        self.model = model
        subscribeTo(searchText: searchTextStream.searchText, searchMode: searchModeStream.searchMode)
    }

    func onSearchInputData(_ searchText: String, _ searchMode: SearchMode) {
        let searchResultData = model.performSearch(for: searchText, mode: searchMode)

        searchResult.accept(searchResultData)
    }

    private func subscribeTo(searchText: Observable<String>, searchMode: Observable<SearchMode>) {
        Observable.combineLatest(searchText, searchMode)
            .subscribe(onNext: { [weak self] (searchText, searchMode) in
                self?.onSearchInputData(searchText, searchMode)
            }).disposed(by: disposeBag)
    }
}

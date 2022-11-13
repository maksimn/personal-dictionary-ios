//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class SearchWordListViewModelImpl: SearchWordListViewModel {

    let searchResult: BindableSearchResult

    private let model: SearchWordListModel

    init(initialData: SearchResultData,
         model: SearchWordListModel) {
        searchResult = BindableSearchResult(value: initialData)
        self.model = model
    }
}

//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Observation

@Observable
final class SearchWordListViewModelImpl: SearchWordListViewModel {

    private(set) var searchResult: SearchResultData

    private let model: SearchWordListModel

    private var tasks: [Task<Void, Never>] = []

    init(initialData: SearchResultData,
         model: SearchWordListModel,
         searchTextStream: SearchTextStream,
         searchModeStream: SearchModeStream) {
        searchResult = initialData
        self.model = model
        subscribeTo(searchText: searchTextStream.searchText, searchMode: searchModeStream.searchMode)
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }

    func onSearchInputData(_ searchText: String, _ searchMode: SearchMode) {
        let searchResultData = model.performSearch(for: searchText, mode: searchMode)

        searchResult = searchResultData
    }

    private func subscribeTo(searchText: AsyncStream<String>, searchMode: AsyncStream<SearchMode>) {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                var latestText: String = ""
                let latestMode: SearchMode = .bySourceWord

                for await text in searchText {
                    latestText = text
                    onSearchInputData(latestText, latestMode)
                }
            }
        )
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                let latestText: String = ""
                var latestMode: SearchMode = .bySourceWord

                for await mode in searchMode {
                    latestMode = mode
                    onSearchInputData(latestText, latestMode)
                }
            }
        )
    }
}

//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Observation

/// Implementation of the favorite word list view model.
@Observable
final class FavoriteWordListViewModelImpl: FavoriteWordListViewModel {

    var favoriteWordList: WordListState = []

    private let fetcher: FavoriteWordListFetcher

    init(fetcher: FavoriteWordListFetcher) {
        self.fetcher = fetcher
    }

    func fetchFavoriteWordList() {
        do {
            let wordList = try fetcher.favoriteWordList()

            favoriteWordList = wordList
        } catch { }
    }
}

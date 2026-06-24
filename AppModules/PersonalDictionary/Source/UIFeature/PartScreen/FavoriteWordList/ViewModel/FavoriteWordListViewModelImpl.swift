//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Implementation of the favorite word list view model.
final class FavoriteWordListViewModelImpl: FavoriteWordListViewModel {

    let favoriteWordList = BindableWordList([])

    private let fetcher: FavoriteWordListFetcher

    init(fetcher: FavoriteWordListFetcher) {
        self.fetcher = fetcher
    }

    func fetchFavoriteWordList() {
        do {
            let wordList = try fetcher.favoriteWordList()

            favoriteWordList.send(wordList)
        } catch { }
    }
}

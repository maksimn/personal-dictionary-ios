//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Реализация модели представления списка избранных слов.
final class FavoriteWordListViewModelImpl: FavoriteWordListViewModel {

    let favoriteWordList = BindableWordList(value: [])

    private let fetcher: FavoriteWordListFetcher

    init(fetcher: FavoriteWordListFetcher) {
        self.fetcher = fetcher    }

    func fetchFavoriteWordList() {
        do {
            let wordList = try fetcher.favoriteWordList()

            favoriteWordList.accept(wordList)
        } catch { }
    }
}

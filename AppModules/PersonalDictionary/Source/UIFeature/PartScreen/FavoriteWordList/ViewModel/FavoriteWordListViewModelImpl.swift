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
    private let wordStream: UpdatedWordStream
    private let disposeBag = DisposeBag()

    init(fetcher: FavoriteWordListFetcher, wordStream: UpdatedWordStream) {
        self.fetcher = fetcher
        self.wordStream = wordStream
        subscribeToWordStream()
    }

    func fetchFavoriteWordList() {
        let wordList = fetcher.favoriteWordList

        favoriteWordList.accept(wordList)
    }

    private func subscribeToWordStream() {
        wordStream.updatedWord
            .subscribe(onNext: { [weak self] _ in
                self?.fetchFavoriteWordList()
            }).disposed(by: disposeBag)
    }
}

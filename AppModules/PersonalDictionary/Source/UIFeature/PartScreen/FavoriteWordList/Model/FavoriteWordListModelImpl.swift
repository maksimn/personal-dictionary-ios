//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

final class FavoriteWordListModelImpl: FavoriteWordListModel {

    private let favoriteWordListFetcher: FavoriteWordListFetcher
    private let wordStream: ReadableWordStream

    private var viewModelBlock: () -> FavoriteWordListViewModel?
    private weak var viewModel: FavoriteWordListViewModel?

    private let disposeBag = DisposeBag()

    init(
        viewModelBlock: @escaping () -> FavoriteWordListViewModel?,
        favoriteWordListFetcher: FavoriteWordListFetcher,
        wordStream: ReadableWordStream
    ) {
        self.viewModelBlock = viewModelBlock
        self.favoriteWordListFetcher = favoriteWordListFetcher
        self.wordStream = wordStream

        subscribeToWordStream()
    }

    func update() {
        let wordList = favoriteWordListFetcher.favoriteWordList

        initViewModelIfNeeded()
        viewModel?.favoriteWordList.accept(wordList)
    }

    private func subscribeToWordStream() {
        wordStream.updatedWord
            .subscribe(onNext: { [weak self] _ in self?.update() })
            .disposed(by: disposeBag)
    }

    private func initViewModelIfNeeded() {
        if viewModel == nil {
            viewModel = viewModelBlock()
        }
    }
}

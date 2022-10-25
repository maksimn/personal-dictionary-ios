//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Реализация графа фичи "Список избранных слов".
final class FavoriteWordListGraphImpl: FavoriteWordListGraph {

    /// View controller для показа экрана/части экрана со списком избранных слов
    private(set) var viewController: UIViewController

    /// Модель списка слов
    private(set) weak var model: FavoriteWordListModel?

    init(wordListBuilder: WordListBuilder,
         favoriteWordListFetcher: FavoriteWordListFetcher,
         wordItemStream: ReadableWordItemStream,
         noFavoriteWordsText: String) {
        weak var viewModelLazy: FavoriteWordListViewModel?

        let model = FavoriteWordListModelImpl(
            viewModelBlock: { viewModelLazy },
            favoriteWordListFetcher: favoriteWordListFetcher,
            wordItemStream: wordItemStream
        )
        let viewModel = FavoriteWordListViewModelImpl(model: model)
        let view = FavoriteWordListView(
            viewModel: viewModel,
            wordListBuilder: wordListBuilder,
            noFavoriteWordsText: noFavoriteWordsText
        )

        viewModelLazy = viewModel

        viewController = view
        self.model = model
    }
}

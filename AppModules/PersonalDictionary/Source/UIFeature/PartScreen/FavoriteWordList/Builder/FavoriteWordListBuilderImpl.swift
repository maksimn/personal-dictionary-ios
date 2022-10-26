//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    private let appConfig: AppConfig

    private let bundle: Bundle

    init(appConfig: AppConfig,
         bundle: Bundle) {
        self.appConfig = appConfig
        self.bundle = bundle
    }

    func build() -> UIViewController {
        weak var viewModelLazy: FavoriteWordListViewModel?

        let model = FavoriteWordListModelImpl(
            viewModelBlock: { viewModelLazy },
            favoriteWordListFetcher: CoreWordListRepository(appConfig: appConfig, bundle: bundle),
            wordItemStream: WordItemStreamImpl.instance
        )
        let viewModel = FavoriteWordListViewModelImpl(model: model)
        let view = FavoriteWordListView(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(
                shouldAnimateWhenAppear: false,
                appConfig: appConfig,
                bundle: bundle
            ),
            noFavoriteWordsText: bundle.moduleLocalizedString("No favorite words")
        )

        viewModelLazy = viewModel

        return view
    }
}

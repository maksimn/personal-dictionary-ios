//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class FavoriteWordListBuilderImpl: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let bundle = dependency.bundle
        weak var viewModelLazy: FavoriteWordListViewModel?

        let model = FavoriteWordListModelImpl(
            viewModelBlock: { viewModelLazy },
            favoriteWordListFetcher: WordListRepositoryImpl(appConfig: dependency.appConfig, bundle: bundle),
            wordStream: WordStreamImpl.instance
        )
        let viewModel = FavoriteWordListViewModelImpl(model: model)
        let view = FavoriteWordListView(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: false, dependency: dependency),
            noFavoriteWordsText: bundle.moduleLocalizedString("MLS_NO_FAVORITE_WORDS"),
            theme: Theme.data
        )

        viewModelLazy = viewModel

        return view
    }
}

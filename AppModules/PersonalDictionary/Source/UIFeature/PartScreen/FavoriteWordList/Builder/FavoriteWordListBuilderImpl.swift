//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class FavoriteWordListBuilderImpl: ViewControllerBuilder {

    private weak var dependency: RootDependency?

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }
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
            noFavoriteWordsText: bundle.moduleLocalizedString("No favorite words")
        )

        viewModelLazy = viewModel

        return view
    }
}

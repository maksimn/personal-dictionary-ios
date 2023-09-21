//
//  FavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

final class FavoriteWordListBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let favoriteWordListFetcherFactory = FavoriteWordListFetcherFactory(
            featureName: "PersonalDictionary.FavoriteWordList")
        let viewModel = FavoriteWordListViewModelImpl(
            fetcher: favoriteWordListFetcherFactory.create(),
            wordStream: WordStreamImpl.instance
        )
        let view = FavoriteWordListViewController(
            viewModel: viewModel,
            wordListBuilder: wordListBuilder(),
            labelText: labelText(),
            theme: Theme.data
        )

        return view
    }

    private func labelText() -> String {
        dependency.bundle.moduleLocalizedString("LS_NO_FAVORITE_WORDS")
    }

    private func wordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            shouldAnimateWhenAppear: false,
            dependency: dependency
        )
    }
}

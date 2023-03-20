//
//  FavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class FavoritesBuilder: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let fetcher = WordListRepositoryImpl(
            langData: dependency.appConfig.langData,
            bundle: dependency.bundle
        )
        let viewModel = FavoritesViewModelImpl(
            fetcher: fetcher,
            wordStream: WordStreamImpl.instance
        )
        let view = FavoritesViewController(
            title: title(),
            viewModel: viewModel,
            wordListBuilder: wordListBuilder(),
            labelText: labelText(),
            theme: Theme.data
        )

        return view
    }

    private func title() -> String {
        dependency.bundle.moduleLocalizedString("LS_FAVORITE_WORDS")
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

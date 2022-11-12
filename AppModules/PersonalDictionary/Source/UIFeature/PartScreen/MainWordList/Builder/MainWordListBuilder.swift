//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilder: ViewControllerBuilder {

    private weak var dependency: RootDependency?

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - Экран "Главного (основного) списка слов".
    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }

        let wordListFetcher = WordListRepositoryImpl(appConfig: dependency.appConfig, bundle: dependency.bundle)
        let viewModel = MainWordListViewModelImpl(wordListFetcher: wordListFetcher)
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }
}

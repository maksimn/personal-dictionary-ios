//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: ViewControllerBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - Экран "Главного (основного) списка слов".
    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }

        return MainWordListViewController(
            viewParams: MainWordListViewParams(
                heading: dependency.bundle.moduleLocalizedString("My dictionary"),
                visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
            ),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency),
            wordListFetcher: CoreWordListRepository(appConfig: dependency.appConfig, bundle: dependency.bundle),
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: dependency)
        )
    }
}

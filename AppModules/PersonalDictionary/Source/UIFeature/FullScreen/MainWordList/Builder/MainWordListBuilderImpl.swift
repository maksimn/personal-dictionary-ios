//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

protocol MainWordListDependency: BaseDependency { }

private struct MainWordListDependencyImpl: MainWordListDependency, MainNavigatorDependency {

    let navigationController: UINavigationController?

    let appConfig: AppConfig
}

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder {

    private weak var navigationController: UINavigationController?
    
    private let appConfig: AppConfig

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: MainWordListDependency) {
        appConfig = dependency.appConfig
        navigationController = dependency.navigationController
    }

    /// Создать экран.
    /// - Returns:
    ///  - Экран "Главного (основного) списка слов".
    func build() -> UIViewController {
        let mainWordListDependency = MainWordListDependencyImpl(
            navigationController: navigationController,
            appConfig: appConfig
        )

        return MainWordListViewController(
            viewParams: viewParams,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, appConfig: appConfig),
            wordListFetcher: CoreWordListRepository(appConfig: appConfig),
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: mainWordListDependency)
        )
    }

    private var viewParams: MainWordListViewParams {
        MainWordListViewParams(
            heading: appConfig.bundle.moduleLocalizedString("My dictionary"),
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }
}

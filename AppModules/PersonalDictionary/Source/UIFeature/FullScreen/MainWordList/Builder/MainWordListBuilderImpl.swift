//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

protocol MainWordListDependency: BaseDependency { }

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder, BaseDependency {

    private(set) weak var navigationController: UINavigationController?
    
    let appConfig: Config

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
        MainWordListViewController(
            viewParams: createViewParams(),
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, appConfig: appConfig),
            wordListFetcher: WordListRepositoryGraphImpl(appConfig: appConfig).repository,
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: self)
        )
    }

    private func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: Bundle(for: type(of: self)).moduleLocalizedString("My dictionary"),
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }
}

/// Для передачи зависимостей во вложенные фичи.
extension MainWordListBuilderImpl: MainNavigatorDependency { }

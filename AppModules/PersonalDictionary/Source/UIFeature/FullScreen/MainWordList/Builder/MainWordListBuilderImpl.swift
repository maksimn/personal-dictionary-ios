//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

protocol MainWordListDependency: BaseDependency { }

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder, BaseDependency {

    private lazy var bundle = Bundle(for: type(of: self))

    let navigationController: UINavigationController

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
            wordListBuilder: createWordListBuilder(),
            wordListFetcher: wordListRepository,
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: self)
        )
    }

    private func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }

    private func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            params: WordListParams(shouldAnimateWhenAppear: true),
            dependency: self
        )
    }

    private var wordListRepository: WordListRepository {
        WordListRepositoryGraphImpl(appConfig: appConfig).repository
    }
}

/// Для передачи зависимостей во вложенные фичи.
extension MainWordListBuilderImpl: WordListDependency, MainNavigatorDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

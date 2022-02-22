//
//  MainWordListHeaderBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Внешние зависимости фичи "Заголовок Главного списка слов".
protocol MainWordListHeaderDependency: BaseDependency { }

/// Реализация билдера фичи "Заголовок Главного списка слов".
final class MainWordListHeaderBuilderImpl: MainWordListHeaderBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи.
    init(dependency: MainWordListHeaderDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
        self.logger = dependency.logger
        self.wordListRepository = dependency.wordListRepository
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let favoriteWordListBuilder = FavoriteWordListBuilderImpl(dependency: self)
        let router = RoutingToFavoriteWordListImpl(
            navigationController: navigationController,
            favoriteWordListBuilder: favoriteWordListBuilder
        )
        let bundle = Bundle(for: type(of: self))
        let viewParams = MainWordListHeaderViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            routingButtonTitle: "☆"
        )
        let view = MainWordListHeaderView(params: viewParams,
                                          router: router)

        return view
    }
}

/// Для передачи зависимостей во вложенную фичу "Экран списка избранных слов Личного словаря".
extension MainWordListHeaderBuilderImpl: FavoriteWordListDependency { }

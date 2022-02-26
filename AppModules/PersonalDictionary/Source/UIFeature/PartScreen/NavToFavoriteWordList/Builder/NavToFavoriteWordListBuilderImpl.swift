//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Внешние зависимости фичи "Заголовок Главного списка слов".
protocol NavToFavoriteWordListDependency: BaseDependency { }

/// Реализация билдера фичи "Заголовок Главного списка слов".
final class NavToFavoriteWordListBuilderImpl: NavToFavoriteWordListBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи.
    init(dependency: NavToFavoriteWordListDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
        self.logger = dependency.logger
        self.wordListRepository = dependency.wordListRepository
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let favoriteWordListBuilder = FavoriteWordListBuilderImpl(dependency: self)
        let router = NavToFavoriteWordListRouterImpl(
            navigationController: navigationController,
            favoriteWordListBuilder: favoriteWordListBuilder
        )
        let view = NavToFavoriteWordListView(
            routingButtonTitle: "☆",
            router: router
        )

        return view
    }
}

/// Для передачи зависимостей во вложенную фичу "Экран списка избранных слов Личного словаря".
extension NavToFavoriteWordListBuilderImpl: FavoriteWordListDependency { }

//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Внешние зависимости фичи "Элемент навигации на экран Избранного".
protocol NavToFavoritesDependency: BaseDependency { }

/// Реализация билдера фичи ""Элемент навигации на экран Избранного".
final class NavToFavoritesBuilderImpl: NavToFavoritesBuilder {

    private(set) weak var navigationController: UINavigationController?

    let appConfig: AppConfig

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи.
    init(dependency: NavToFavoritesDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let favoritesBuilder = FavoritesBuilderImpl(dependency: self)
        let router = NavToFavoritesRouterImpl(
            navigationController: navigationController,
            favoritesBuilder: favoritesBuilder
        )
        let view = NavToFavoritesView(
            routingButtonTitle: "☆",
            navToFavoritesRouter: router
        )

        return view
    }
}

/// Для передачи зависимостей во вложенную фичу "Экран Избранного".
extension NavToFavoritesBuilderImpl: FavoritesDependency { }

//
//  RoutingToFavoritesImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule

/// Реализация роутера для навигации на экран Избранного.
final class NavToFavoritesRouterImpl: CoreRouter {

    private(set) weak var navigationController: UINavigationController?
    private let favoritesBuilder: FavoritesBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - favoritesBuilder: билдер вложенной фичи "Избранное".
    init(navigationController: UINavigationController?,
         favoritesBuilder: FavoritesBuilder) {
        self.navigationController = navigationController
        self.favoritesBuilder = favoritesBuilder
    }

    /// Перейти на экран списка избранных слов личногр словаря.
    func navigate() {
        let favoritesViewController = favoritesBuilder.build()

        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

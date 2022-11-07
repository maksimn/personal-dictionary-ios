//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Реализация билдера фичи ""Элемент навигации на экран Избранного".
final class NavToFavoritesBuilder: ViewBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        guard let dependency = dependency else { return UIView() }
        let favoritesBuilder = FavoritesBuilderImpl(dependency: dependency)
        let router = NavToFavoritesRouter(
            navigationController: dependency.navigationController,
            favoritesBuilder: favoritesBuilder
        )
        let view = NavToFavoritesView(
            routingButtonTitle: "☆",
            navToFavoritesRouter: router
        )

        return view
    }
}

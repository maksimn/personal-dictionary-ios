//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Implementation of the "Navigation to Favorites Screen" feature builder.
final class NavToFavoritesBuilder: ViewBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Create the feature.
    /// - Returns: feature view.
    func build() -> UIView {
        let favoritesBuilder = FavoritesBuilder(dependency: dependency)
        let router = NavToFavoritesRouter(
            navigationController: dependency.navigationController,
            favoritesBuilder: favoritesBuilder
        )
        let view = NavToFavoritesView(
            routingButtonTitle: dependency.bundle.moduleLocalizedString("LS_FAVORITES"),
            navToFavoritesRouter: router,
            theme: Theme.data
        )

        return view
    }
}

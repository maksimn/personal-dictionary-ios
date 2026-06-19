//
//  RoutingToFavoritesImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Implementation of the router for navigation to the Favorites screen.
final class NavToFavoritesRouter: Router {

    private weak var navigationController: UINavigationController?
    private let favoritesBuilder: ViewControllerBuilder

    /// Initializer.
    /// - Parameters:
    ///  - navigationController: root navigation controller of the application.
    ///  - favoritesBuilder: builder of the "Favorites" feature.
    init(navigationController: UINavigationController?,
         favoritesBuilder: ViewControllerBuilder) {
        self.navigationController = navigationController
        self.favoritesBuilder = favoritesBuilder
    }

    /// Navigate to the favorite words list screen of the personal dictionary.
    func navigate() {
        let favoritesViewController = favoritesBuilder.build()

        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

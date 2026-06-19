//
//  FavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Implementation of the "Favorites" feature builder.
final class FavoritesBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Create the screen.
    /// - Returns:
    ///  - View controller of the screen.
    func build() -> UIViewController {
        FavoritesViewController(
            title: dependency.bundle.moduleLocalizedString("LS_FAVORITE_WORDS"),
            favoriteWordListBuilder: FavoriteWordListBuilder(dependency: dependency),
            theme: Theme.data
        )
    }
}

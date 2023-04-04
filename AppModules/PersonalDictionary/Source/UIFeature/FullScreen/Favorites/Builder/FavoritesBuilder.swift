//
//  FavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Реализация билдера фичи "Избранное".
final class FavoritesBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        FavoritesViewController(
            title: dependency.bundle.moduleLocalizedString("LS_FAVORITE_WORDS"),
            favoriteWordListBuilder: FavoriteWordListBuilder(dependency: dependency),
            theme: Theme.data
        )
    }
}

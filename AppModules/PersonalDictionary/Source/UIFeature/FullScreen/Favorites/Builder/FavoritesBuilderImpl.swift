//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Реализация билдера фичи "Избранное".
final class FavoritesBuilderImpl: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        let bundle = dependency.bundle
        let navToSearchBuilder = NavToSearchBuilderImpl(
            width: .smaller,
            dependency: dependency
        )

        return FavoritesViewController(
            headingText: bundle.moduleLocalizedString("MLS_FAVORITE_WORDS"),
            navToSearchBuilder: navToSearchBuilder,
            favoriteWordListBuilder: FavoriteWordListBuilderImpl(dependency: dependency)
        )
    }
}

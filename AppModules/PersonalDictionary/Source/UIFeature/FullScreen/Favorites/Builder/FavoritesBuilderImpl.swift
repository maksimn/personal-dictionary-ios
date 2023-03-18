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
        FavoritesViewController(
            headingText: dependency.bundle.moduleLocalizedString("LS_FAVORITE_WORDS"),
            navToSearchBuilder: NavToSearchBuilder(dependency: dependency),
            favoriteWordListBuilder: FavoriteWordListBuilder(dependency: dependency),
            theme: Theme.data
        )
    }
}

//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Реализация билдера фичи "Избранное".
final class FavoritesBuilderImpl: FavoritesBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        guard let dependency = dependency else { return UIViewController() }
        let appConfig = dependency.appConfig
        let bundle = dependency.bundle
        let navToSearchBuilder = NavToSearchBuilderImpl(
            width: .smaller,
            dependency: dependency
        )
        let viewParams = FavoritesViewParams(
            heading: bundle.moduleLocalizedString("Favorite words"),
            noFavoriteWordsText: bundle.moduleLocalizedString("No favorite words")
        )

        return FavoritesViewController(
            params: viewParams,
            navToSearchBuilder: navToSearchBuilder,
            favoriteWordListBuilder: FavoriteWordListBuilderImpl(appConfig: appConfig, bundle: bundle)
        )
    }
}

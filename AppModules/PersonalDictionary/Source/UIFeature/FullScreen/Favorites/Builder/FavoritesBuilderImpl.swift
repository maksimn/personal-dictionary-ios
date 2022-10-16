//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

protocol FavoritesDependency: BaseDependency {}

private struct NavToSearchDependencyImpl: NavToSearchDependency {

    let navigationController: UINavigationController?

    let appConfig: AppConfig
}

/// Реализация билдера фичи "Избранное".
final class FavoritesBuilderImpl: FavoritesBuilder {

    private weak var navigationController: UINavigationController?

    private let appConfig: AppConfig

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: FavoritesDependency) {
        navigationController = dependency.navigationController
        appConfig = dependency.appConfig
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        let navToSearchDependency = NavToSearchDependencyImpl(
            navigationController: navigationController,
            appConfig: appConfig
        )
        let navToSearchBuilder = NavToSearchBuilderImpl(width: .smaller, dependency: navToSearchDependency)
        let bundle = appConfig.bundle
        let viewParams = FavoritesViewParams(
            heading: bundle.moduleLocalizedString("Favorite words"),
            noFavoriteWordsText: bundle.moduleLocalizedString("No favorite words")
        )

        return FavoritesViewController(
            params: viewParams,
            navToSearchBuilder: navToSearchBuilder,
            favoriteWordListBuilder: FavoriteWordListBuilderImpl(appConfig: appConfig)
        )
    }
}

//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Реализация билдера фичи "Избранное".
final class FavoritesBuilderImpl: ViewControllerBuilder {

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

        return FavoritesViewController(
            heading: bundle.moduleLocalizedString("Favorite words"),
            navToSearchBuilder: navToSearchBuilder,
            favoriteWordListBuilder: FavoriteWordListBuilderImpl(appConfig: appConfig, bundle: bundle)
        )
    }
}

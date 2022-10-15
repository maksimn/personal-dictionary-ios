//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Внешние зависимости фичи "Экран списка избранных слов".
protocol FavoriteWordListDependency: BaseDependency { }

private struct NavToSearchDependencyImpl: NavToSearchDependency {

    let navigationController: UINavigationController?

    let appConfig: AppConfig
}

/// Реализация билдера фичи "Экран списка избранных слов".
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    private weak var navigationController: UINavigationController?

    private let appConfig: AppConfig

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: FavoriteWordListDependency) {
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
        let wordListBuilder = WordListBuilderImpl(shouldAnimateWhenAppear: false, appConfig: appConfig)
        let bundle = appConfig.bundle
        let viewParams = FavoriteWordListViewParams(
            heading: bundle.moduleLocalizedString("Favorite words"),
            noFavoriteWordsText: bundle.moduleLocalizedString("No favorite words")
        )

        return FavoriteWordListViewController(
            params: viewParams,
            navToSearchBuilder: navToSearchBuilder,
            wordListBuilder: wordListBuilder,
            favoriteWordListFetcher: CoreWordListRepository(appConfig: appConfig),
            wordItemStream: WordItemStreamImpl.instance
        )
    }
}

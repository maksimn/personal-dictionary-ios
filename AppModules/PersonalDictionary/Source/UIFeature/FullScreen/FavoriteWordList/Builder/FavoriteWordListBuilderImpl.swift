//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Внешние зависимости фичи "Экран списка избранных слов".
protocol FavoriteWordListDependency: BaseDependency { }

/// Реализация билдера фичи "Экран списка избранных слов".
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    private(set) weak var navigationController: UINavigationController?

    let appConfig: AppConfig

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: FavoriteWordListDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        let navToSearchBuilder = NavToSearchBuilderImpl(width: .smaller, dependency: self)
        let wordListBuilder = WordListBuilderImpl(shouldAnimateWhenAppear: false, appConfig: appConfig)

        return FavoriteWordListViewController(
            params: createViewParams(),
            navToSearchBuilder: navToSearchBuilder,
            wordListBuilder: wordListBuilder,
            favoriteWordListFetcher: CoreWordListRepository(appConfig: appConfig),
            readableWordItemStream: WordItemStreamImpl.instance
        )
    }

    private func createViewParams() -> FavoriteWordListViewParams {
        FavoriteWordListViewParams(
            heading: appConfig.bundle.moduleLocalizedString("Favorite words"),
            textLabelParams: TextLabelParams(
                textColor: Theme.data.secondaryTextColor,
                font: Theme.data.normalFont,
                text: appConfig.bundle.moduleLocalizedString("No favorite words")
            )
        )
    }
}

/// Для передачи внешних зависимостей во вложенные фичи.
extension FavoriteWordListBuilderImpl: NavToSearchDependency { }

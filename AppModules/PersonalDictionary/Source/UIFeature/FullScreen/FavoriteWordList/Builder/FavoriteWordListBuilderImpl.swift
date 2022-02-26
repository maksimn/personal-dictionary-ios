//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Внешние зависимости фичи "Экран списка избранных слов".
protocol FavoriteWordListDependency: BaseDependency { }

/// Реализация билдера фичи "Экран списка избранных слов".
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: FavoriteWordListDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
        self.logger = dependency.logger
        self.wordListRepository = dependency.wordListRepository
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        let navToSearchBuilder = NavToSearchBuilderImpl(width: .smaller, dependency: self)
        let wordListBuilder = WordListBuilderImpl(params: WordListParams(shouldAnimateWhenAppear: false),
                                                  dependency: self)

        return FavoriteWordListViewController(
            params: createViewParams(),
            navToSearchBuilder: navToSearchBuilder,
            wordListBuilder: wordListBuilder,
            favoriteWordListFetcher: wordListRepository,
            wordItemStream: WordItemStreamImpl.instance
        )
    }

    private func createViewParams() -> FavoriteWordListViewParams {
        let bundle = Bundle(for: type(of: self))

        return FavoriteWordListViewParams(
            heading: bundle.moduleLocalizedString("Favorite words"),
            textLabelParams: TextLabelParams(
                textColor: .darkGray,
                font: Theme.standard.normalFont,
                text: bundle.moduleLocalizedString("No favorite words")
            )
        )
    }
}

/// Для передачи внешних зависимостей во вложенные фичи.
extension FavoriteWordListBuilderImpl: WordListDependency, NavToSearchDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

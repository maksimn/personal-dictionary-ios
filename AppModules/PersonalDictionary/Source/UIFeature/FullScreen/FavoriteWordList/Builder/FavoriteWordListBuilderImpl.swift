//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Внешние зависимости фичи "Экран списка избранных слов".
protocol FavoriteWordListExternals {

    var navigationController: UINavigationController { get }

    var appConfig: Config { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Экран списка избранных слов".
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    init(externals: FavoriteWordListExternals) {
        self.navigationController = externals.navigationController
        self.appConfig = externals.appConfig
        self.logger = externals.logger
        self.wordListRepository = externals.wordListRepository
    }

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController {
        let navToSearchBuilder = NavToSearchBuilderImpl(width: .smaller, externals: self)
        let wordListBuilder = WordListBuilderImpl(params: WordListParams(shouldAnimateWhenAppear: false),
                                                  externals: self)

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

/// Для передачи внешних зависимостей в фичу "Список слов"
extension FavoriteWordListBuilderImpl: WordListExternals {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

/// Для передачи внешних зависимостей в фичу "Навигация на экран Поиска"
extension FavoriteWordListBuilderImpl: NavToSearchExternals { }

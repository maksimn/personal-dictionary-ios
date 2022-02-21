//
//  FavoriteWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

protocol FavoriteWordListExternals {

    var navigationController: UINavigationController { get }

    var appConfig: AppConfigs { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Билдер Фичи.
final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    let navigationController: UINavigationController

    let appConfig: AppConfigs

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
        let bundle = Bundle(for: type(of: self))
        let navToSearchBuilder = NavToSearchBuilderImpl(width: .smaller, externals: self)

        return FavoriteWordListViewController(
            params: FavoriteWordListViewParams(heading: bundle.moduleLocalizedString("Favorite words")),
            navToSearchBuilder: navToSearchBuilder
        )
    }
}

extension FavoriteWordListBuilderImpl: NavToSearchExternals { }

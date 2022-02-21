//
//  MainWordListHeaderBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

protocol MainWordListHeaderExternals {

    var navigationController: UINavigationController { get }

    var appConfig: AppConfigs { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Заголовок Главного списка слов".
final class MainWordListHeaderBuilderImpl: MainWordListHeaderBuilder {

    let navigationController: UINavigationController

    let appConfig: AppConfigs

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    init(externals: MainWordListHeaderExternals) {
        self.navigationController = externals.navigationController
        self.appConfig = externals.appConfig
        self.logger = externals.logger
        self.wordListRepository = externals.wordListRepository
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let favoriteWordListBuilder = FavoriteWordListBuilderImpl(externals: self)
        let router = RoutingToFavoriteWordListImpl(navigationController: navigationController,
                                                   favoriteWordListBuilder: favoriteWordListBuilder)
        let bundle = Bundle(for: type(of: self))
        let viewParams = MainWordListHeaderViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            routingButtonTitle: "☆"
        )
        let view = MainWordListHeaderView(params: viewParams,
                                          router: router)

        return view
    }
}

extension MainWordListHeaderBuilderImpl: FavoriteWordListExternals { }

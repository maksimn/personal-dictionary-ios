//
//  MainWordListHeaderBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Внешние зависимости фичи "Заголовок Главного списка слов".
protocol MainWordListHeaderExternals {

    var navigationController: UINavigationController { get }

    var appConfig: Config { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Заголовок Главного списка слов".
final class MainWordListHeaderBuilderImpl: MainWordListHeaderBuilder {

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
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
        let router = RoutingToFavoriteWordListImpl(
            navigationController: navigationController,
            favoriteWordListBuilder: favoriteWordListBuilder
        )
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

/// Для передачи зависимостей во вложенную фичу "Экран списка избранных слов Личного словаря".
extension MainWordListHeaderBuilderImpl: FavoriteWordListExternals { }

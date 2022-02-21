//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

enum NavToSearchWidth {
    case full
    case smaller
}

protocol NavToSearchExternals {

    var navigationController: UINavigationController { get }

    var appConfig: AppConfigs { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    let width: NavToSearchWidth

    let navigationController: UINavigationController

    let appConfig: AppConfigs

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    init(width: NavToSearchWidth,
         externals: NavToSearchExternals) {
        self.width = width
        self.navigationController = externals.navigationController
        self.appConfig = externals.appConfig
        self.logger = externals.logger
        self.wordListRepository = externals.wordListRepository
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let searchBuilder = SearchBuilderImpl(externals: self)
        let router = NavToSearchRouterImpl(navigationController: navigationController,
                                           searchBuilder: searchBuilder)
        let view = NavToSearchView(width: width, router: router)

        return view
    }
}

extension NavToSearchBuilderImpl: SearchExternals { }

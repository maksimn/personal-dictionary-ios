//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Ширина представления фичи "Навигация на экран Поиска".
enum NavToSearchWidth {
    case full /// полная (во всю ширину экрана).
    case smaller /// меньшая ширина, чем full.
}

/// Внешние зависимости фичи "Навигация на экран Поиска".
protocol NavToSearchExternals {

    var navigationController: UINavigationController { get }

    var appConfig: Config { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    let width: NavToSearchWidth

    let navigationController: UINavigationController

    let appConfig: Config

    let logger: Logger

    let wordListRepository: WordListRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - width: параметр ширины представления.
    ///  - externals: внешние зависимости фичи .
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

/// Для передачи внешних зависимостей в фичу "Поиск по словам Личного словаря".
extension NavToSearchBuilderImpl: SearchExternals { }

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
protocol NavToSearchDependency: BaseDependency { }

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    let width: NavToSearchWidth

    private(set) weak var navigationController: UINavigationController?

    let appConfig: AppConfig

    /// Инициализатор.
    /// - Parameters:
    ///  - width: параметр ширины представления.
    ///  - dependency: внешние зависимости фичи .
    init(width: NavToSearchWidth,
         dependency: NavToSearchDependency) {
        self.width = width
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let searchBuilder = SearchBuilderImpl(appConfig: appConfig)
        let router = NavToSearchRouterImpl(navigationController: navigationController,
                                           searchBuilder: searchBuilder)
        let view = NavToSearchView(width: width, router: router)

        return view
    }
}

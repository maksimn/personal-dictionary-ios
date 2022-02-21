//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Реализация билдера фичи "Навигация на экран Поиска".
final class NavToSearchBuilderImpl: NavToSearchBuilder {

    private let navigationController: UINavigationController
    private let searchBuilder: SearchBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    init(navigationController: UINavigationController,
         searchBuilder: SearchBuilder) {
        self.navigationController = navigationController
        self.searchBuilder = searchBuilder
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let router = NavToSearchRouterImpl(navigationController: navigationController,
                                           searchBuilder: searchBuilder)
        let view = NavToSearchView(router: router)

        return view
    }
}

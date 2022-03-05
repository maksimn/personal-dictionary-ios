//
//  MainNavigatorBuilderImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Зависимости фичи.
protocol MainNavigatorDependency: BaseDependency { }

/// Реализация билдера фичи "Контейнер элементов навигации на Главном экране приложения".
final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    private(set) weak var navigationController: UINavigationController?

    let appConfig: Config

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: MainNavigatorDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
    }

    /// Создать контейнер.
    /// - Returns: объект контейнера.
    func build() -> MainNavigator {
        MainNavigatorImpl(
            navigationController: navigationController,
            navToSearchBuilder: NavToSearchBuilderImpl(width: .full, dependency: self),
            navToFavoriteWordListBuilder: NavToFavoriteWordListBuilderImpl(dependency: self),
            navToNewWordBuilder: NavToNewWordBuilderImpl(dependency: self),
            navToOtherAppBuilder: NavToOtherAppBuilderImpl(rootViewController: navigationController)
        )
    }
}

extension MainNavigatorBuilderImpl: NavToSearchDependency,
                                    NavToFavoriteWordListDependency,
                                    NavToNewWordDependency { }

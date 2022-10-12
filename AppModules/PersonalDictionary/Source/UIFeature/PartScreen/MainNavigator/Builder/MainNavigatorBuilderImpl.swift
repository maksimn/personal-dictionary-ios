//
//  MainNavigatorBuilderImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Зависимости фичи.
protocol MainNavigatorDependency: BaseDependency { }

private struct MainNavigatorDependencyImpl: MainNavigatorDependency,
                                            NavToSearchDependency,
                                            NavToFavoriteWordListDependency,
                                            NavToNewWordDependency {

    let navigationController: UINavigationController?

    let appConfig: AppConfig
}

/// Реализация билдера фичи "Контейнер элементов навигации на Главном экране приложения".
final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    private let dependency: MainNavigatorDependency

    /// Инициализатор,
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: MainNavigatorDependency) {
        self.dependency = dependency
    }

    /// Создать контейнер.
    /// - Returns: объект контейнера.
    func build() -> MainNavigator {
        let dependency = MainNavigatorDependencyImpl(
            navigationController: dependency.navigationController,
            appConfig: dependency.appConfig
        )

        return MainNavigatorImpl(
            navigationController: dependency.navigationController,
            navToSearchBuilder: NavToSearchBuilderImpl(width: .full, dependency: dependency),
            navToFavoriteWordListBuilder: NavToFavoriteWordListBuilderImpl(dependency: dependency),
            navToNewWordBuilder: NavToNewWordBuilderImpl(dependency: dependency),
            navToTodoListAppBuilder: NavToTodoListAppBuilderImpl(
                rootViewController: dependency.navigationController,
                bundle: dependency.appConfig.bundle
            )
        )
    }
}

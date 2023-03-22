//
//  MainNavigatorBuilderImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import CoreModule

/// Реализация билдера фичи "Контейнер элементов навигации на Главном экране приложения".
final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать контейнер.
    /// - Returns: объект контейнера.
    func build() -> MainNavigator {
        MainNavigatorImpl(
            navigationController: dependency.navigationController,
            searchTextInputBuilder: SearchTextInputBuilder(bundle: dependency.bundle),
            navToSearchBuilder: NavToSearchBuilderImpl(dependency: dependency),
            navToNewWordBuilder: NavToNewWordBuilder(dependency: dependency),
            navToFavoritesBuilder: NavToFavoritesBuilder(dependency: dependency),
            navToTodoListBuilder: NavToTodoListBuilder(
                rootViewController: dependency.navigationController,
                bundle: dependency.bundle
            ),
            logger: SLoggerImp(category: "PersonalDictionary.MainNavigator")
        )
    }
}

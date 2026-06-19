//
//  MainNavigatorBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import CoreModule
import UIKit

/// Implementation of the "Container of Navigation Elements on the Main Screen" feature builder.
final class MainNavigatorBuilderImpl: MainNavigatorBuilder {

    private let navigationItemGetter: () -> UINavigationItem?
    private let dependency: AppDependency

    init(navigationItemGetter: @escaping () -> UINavigationItem?, dependency: AppDependency) {
        self.navigationItemGetter = navigationItemGetter
        self.dependency = dependency
    }

    /// Create the container.
    /// - Returns: container object.
    func build() -> MainNavigator {
        MainNavigatorImpl(
            navigationItemGetter: navigationItemGetter,
            searchControllerBuilder: SearchTextInputBuilder(bundle: dependency.bundle),
            navToSearchBuilder: NavToSearchBuilderImpl(dependency: dependency),
            navToNewWordBuilder: NavToNewWordBuilder(dependency: dependency),
            navToFavoritesBuilder: NavToFavoritesBuilder(dependency: dependency),
            navToTodoListBuilder: NavToTodoListBuilder(
                rootViewController: dependency.navigationController,
                bundle: dependency.bundle
            ),
            logger: LoggerImpl(category: "PersonalDictionary.MainNavigator")
        )
    }
}

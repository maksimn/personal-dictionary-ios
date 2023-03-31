//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Главный экран приложения" Личного словаря.
final class MainScreenBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - Главный экран приложения.
    func build() -> UIViewController {
        var navigationItem: UINavigationItem?

        let mainNavigatorBuilder = MainNavigatorBuilderImpl(
            navigationItemGetter: { navigationItem },
            dependency: dependency
        )
        let mainScreen = MainScreen(
            title: dependency.bundle.moduleLocalizedString("LS_MY_DICTIONARY"),
            mainWordListBuilder: MainWordListBuilder(dependency: dependency),
            mainNavigatorBuilder: mainNavigatorBuilder,
            theme: Theme.data,
            logger: LoggerImpl(category: "PersonalDictionary.MainScreen")
        )

        navigationItem = mainScreen.navigationItem

        return mainScreen
    }
}

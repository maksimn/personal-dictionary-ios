//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

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
        MainScreen(
            heading: dependency.bundle.moduleLocalizedString("LS_MY_DICTIONARY"),
            mainWordListBuilder: MainWordListBuilder(dependency: dependency),
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: dependency),
            theme: Theme.data
        )
    }
}

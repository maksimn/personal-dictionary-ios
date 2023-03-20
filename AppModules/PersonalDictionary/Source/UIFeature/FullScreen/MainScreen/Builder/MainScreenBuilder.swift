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
        MainScreen(
            heading: dependency.bundle.moduleLocalizedString("LS_MY_DICTIONARY"),
            mainWordListBuilder: MainWordListBuilder(dependency: dependency),
            searchTextInputBuilder: SearchTextInputBuilder(bundle: dependency.bundle),
            navToSearchBuilder: NavToSearchBuilder(dependency: dependency),
            navToFavoritesBuilder: NavToFavoritesBuilder(dependency: dependency),
            navToTodoListBuilder: NavToTodoListBuilder(
                rootViewController: dependency.navigationController,
                bundle: dependency.bundle
            ),
            theme: Theme.data
        )
    }
}

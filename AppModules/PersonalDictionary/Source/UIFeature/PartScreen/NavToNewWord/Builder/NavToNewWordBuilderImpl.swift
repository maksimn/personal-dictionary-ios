//
//  NavToNewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

protocol NavToNewWordDependency: BaseDependency { }

/// Реализация билдера фичи "Навигация на экран добавления нового слова".
final class NavToNewWordBuilderImpl: NavToNewWordBuilder {

    private weak var navigationController: UINavigationController?

    let appConfig: AppConfig

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи .
    init(dependency: NavToNewWordDependency) {
        self.navigationController = dependency.navigationController
        self.appConfig = dependency.appConfig
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let newWordBuilder = NewWordBuilderImpl(
            bundle: appConfig.bundle,
            langRepository: langRepository
        )
        let router = NavToNewWordRouterImpl(
            navigationController: navigationController,
            newWordBuilder: newWordBuilder
        )
        let view = NavToNewWordView(
            navToNewWordImage: UIImage(named: "icon-plus", in: appConfig.bundle, compatibleWith: nil)!,
            router: router
        )

        return view
    }

    private var langRepository: LangRepository {
        LangRepositoryImpl(userDefaults: UserDefaults.standard, data: appConfig.langData)
    }
}

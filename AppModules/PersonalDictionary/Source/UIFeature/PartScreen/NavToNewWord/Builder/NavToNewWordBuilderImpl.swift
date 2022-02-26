//
//  NavToNewWordBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Внешние зависимости фичи "Навигация".
protocol NavToNewWordDependency {

    var navigationController: UINavigationController { get }

    var langRepository: LangRepository { get }
}

/// Реализация билдера фичи "Навигация".
final class NavToNewWordBuilderImpl: NavToNewWordBuilder {

    let navigationController: UINavigationController

    let langRepository: LangRepository

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: внешние зависимости фичи .
    init(dependency: NavToNewWordDependency) {
        self.navigationController = dependency.navigationController
        self.langRepository = dependency.langRepository
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let newWordBuilder = NewWordBuilderImpl(dependency: self)
        let router = NavToNewWordRouterImpl(navigationController: navigationController,
                                            newWordBuilder: newWordBuilder)
        let view = NavToNewWordView(navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
                                    router: router)

        return view
    }
}

/// Для передачи зависимостей во вложенную фичу.
extension NavToNewWordBuilderImpl: NewWordDependency { }

//
//  NavToSearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import TodoList
import UIKit

/// Реализация билдера фичи "Навигация к другому продукту/приложению в супераппе".
final class NavToTodoListAppBuilderImpl: ViewBuilder {

    private weak var rootViewController: UIViewController?
    private let bundle: Bundle

    init(rootViewController: UIViewController?,
         bundle: Bundle) {
        self.rootViewController = rootViewController
        self.bundle = bundle
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let router = RoutingToTodoListAppRouter(
            rootViewController: rootViewController ?? UIViewController(),
            todoListAppBuilder: TodoList.MainBuilderImp()
        )

        return NavToOtherAppView(
            routingButtonTitle: bundle.moduleLocalizedString("My todos"),
            router: router
        )
    }
}

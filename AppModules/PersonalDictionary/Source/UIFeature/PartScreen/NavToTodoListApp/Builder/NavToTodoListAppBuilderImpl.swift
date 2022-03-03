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
final class NavToOtherAppBuilderImpl: NavToOtherAppBuilder {

    private weak var rootViewController: UIViewController?

    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let router = RoutingToTodoListAppRouter(
            rootViewController: rootViewController ?? UIViewController(),
            todoListAppBuilder: TodoListAppBuilderImpl()
        )

        return NavToOtherAppView(
            routingButtonTitle: Bundle(for: type(of: self)).moduleLocalizedString("My todos"),
            router: router
        )
    }
}

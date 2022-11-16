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
final class NavToTodoListBuilder: ViewBuilder {

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
        let router = NavToTodoListRouter(
            rootViewController: rootViewController ?? UIViewController(),
            todoListBuilder: TodoList.MainBuilderImp()
        )

        return NavToTodoListView(
            routingButtonTitle: bundle.moduleLocalizedString("My todos"),
            router: router
        )
    }
}
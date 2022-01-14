//
//  SuperListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import PersonalDictionary
import TodoList
import UIKit

/// Реализация супераппа ("основного приложения").
final class SuperAppImpl: SuperApp {

    /// Главный экран супераппа.
    let rootViewController = UIViewController()

    /// Инициализатор объекта супераппа.
    /// - Parameters:
    ///  - todoListAppBuilder: билдер приложения TodoList ("Список дел").
    init(todoListAppBuilder: TodoListAppBuilder) {
        let personalDictionaryAppBuilder = buildPersonalDictionaryAppBuilder(
            todoListAppBuilder: todoListAppBuilder
        )
        let personalDictionaryApp = personalDictionaryAppBuilder.build()

        rootViewController.add(childViewController: personalDictionaryApp.navigationController)
    }

    private func buildPersonalDictionaryAppBuilder(
        todoListAppBuilder: TodoListAppBuilder
    ) -> PersonalDictionaryAppBuilder {
        let routeToTodoListButtonTitle = NSLocalizedString("My todos", comment: "")
        let routingToTodoListAppRouter = RoutingToTodoListAppRouter(
            rootViewController: rootViewController,
            todoListAppBuilder: todoListAppBuilder
        )
        let personalDictionaryAppParams = PersonalDictionaryAppParams(
            coreRouter: routingToTodoListAppRouter,
            routingButtonTitle: routeToTodoListButtonTitle
        )

        return PersonalDictionaryAppBuilderImpl(appParams: personalDictionaryAppParams)
    }
}

//
//  SuperListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import PersonalDictionary
import TodoList
import UIKit

final class SuperAppImpl: SuperApp {

    let rootViewController = UIViewController()

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

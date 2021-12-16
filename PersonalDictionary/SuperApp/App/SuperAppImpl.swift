//
//  SuperListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

final class SuperAppImpl: SuperApp {

    let rootViewController = UIViewController()

    init() {
        let routeToTodoListButtonTitle = NSLocalizedString("My todos", comment: "")
        let routeToPersonalDictionaryButtonTitle = NSLocalizedString("My dictionary", comment: "")

        let todoListAppBuilder = TodoListAppBuilderImpl(
            routingButtonTitle: routeToPersonalDictionaryButtonTitle
        )
        let routingToTodoListAppRouter = RoutingToTodoListAppRouter(
            rootViewController: rootViewController,
            todoListAppBuilder: todoListAppBuilder
        )
        let personalDictionaryAppBuilder = PersonalDictionaryAppBuilderImpl(
            coreRouter: routingToTodoListAppRouter,
            routingButtonTitle: routeToTodoListButtonTitle
        )
        let personalDictionaryApp = personalDictionaryAppBuilder.build()

        rootViewController.add(childViewController: personalDictionaryApp.navigationController)
    }
}

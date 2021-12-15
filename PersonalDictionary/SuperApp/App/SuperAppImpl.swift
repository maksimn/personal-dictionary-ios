//
//  SuperListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

final class SuperAppImpl: SuperApp {

    let rootViewController = UIViewController()

    init(routeToTodoListButtonTitle: String,
         routeToPersonalDictionaryButtonTitle: String) {
        let todoListAppBuilder = TodoListAppBuilderImpl(
            superAppRoutingButtonTitle: routeToPersonalDictionaryButtonTitle
        )
        let superAppRouterToTodoList = SuperAppRouterToTodoList(
            rootViewController: rootViewController,
            todoListAppBuilder: todoListAppBuilder
        )
        let personalDictionaryAppBuilder =
            PersonalDictionaryAppBuilderImpl(superAppRouter: superAppRouterToTodoList,
                                             superAppRoutingButtonTitle: routeToTodoListButtonTitle)
        let personalDictionaryApp = personalDictionaryAppBuilder.build()

        rootViewController.add(childViewController: personalDictionaryApp.navigationController)
    }
}

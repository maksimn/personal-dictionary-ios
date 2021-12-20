//
//  NavigateToTodoListAppRouter.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import TodoList
import UIKit

final class RoutingToTodoListAppRouter: CoreRouter {

    private let rootViewController: UIViewController
    private let todoListAppBuilder: TodoListAppBuilder

    init(rootViewController: UIViewController,
         todoListAppBuilder: TodoListAppBuilder) {
        self.rootViewController = rootViewController
        self.todoListAppBuilder = todoListAppBuilder
    }

    func navigate() {
        let todoListApp = todoListAppBuilder.build()
        let todoListViewController = todoListApp.navigationController

        todoListViewController.modalPresentationStyle = .fullScreen

        rootViewController.present(todoListViewController, animated: true, completion: nil)
    }
}

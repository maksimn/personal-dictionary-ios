//
//  NavigateToTodoListAppRouter.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import TodoList
import UIKit

/// Роутер, предназначенный для перехода к приложению "Список дел" (TodoList).
final class RoutingToTodoListAppRouter: CoreRouter {

    private let rootViewController: UIViewController
    private let todoListAppBuilder: TodoListAppBuilder

    /// - Parameters:
    ///   - rootViewController: view контроллер экрана, с которого начинается переход к приложению "Список дел" (TodoList).
    ///   - todoListAppBuilder: билдер приложения TodoList ("Список дел").
    init(rootViewController: UIViewController,
         todoListAppBuilder: TodoListAppBuilder) {
        self.rootViewController = rootViewController
        self.todoListAppBuilder = todoListAppBuilder
    }

    /// Перейти к приложению "Список дел" (TodoList).
    func navigate() {
        let todoListApp = todoListAppBuilder.build()
        let todoListViewController = todoListApp.navigationController

        todoListViewController.modalPresentationStyle = .fullScreen

        rootViewController.present(todoListViewController, animated: true, completion: nil)
    }
}

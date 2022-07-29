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
    private let todoListAppBuilder: TodoList.MainBuilder

    /// - Parameters:
    ///   - rootViewController: view контроллер экрана, с которого начинается переход к приложению "Список дел" (TodoList).
    ///   - todoListAppBuilder: билдер приложения TodoList ("Список дел").
    init(rootViewController: UIViewController,
         todoListAppBuilder: TodoList.MainBuilder) {
        self.rootViewController = rootViewController
        self.todoListAppBuilder = todoListAppBuilder
    }

    /// Перейти к приложению "Список дел" (TodoList).
    func navigate() {
        let todoListNavigationController = todoListAppBuilder.build()

        todoListNavigationController.modalPresentationStyle = .fullScreen

        rootViewController.present(todoListNavigationController, animated: true, completion: nil)
    }
}

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
final class NavToTodoListRouter: CoreRouter {

    private let rootViewController: UIViewController
    private let todoListBuilder: TodoList.MainBuilder

    /// - Parameters:
    ///   - rootViewController: view контроллер экрана, с которого начинается переход к приложению "Список дел" (TodoList).
    ///   - todoListBuilder: билдер приложения TodoList ("Список дел").
    init(rootViewController: UIViewController,
         todoListBuilder: TodoList.MainBuilder) {
        self.rootViewController = rootViewController
        self.todoListBuilder = todoListBuilder
    }

    /// Перейти к приложению "Список дел" (TodoList).
    func navigate() {
        let todoListViewController = todoListBuilder.build()

        todoListViewController.modalPresentationStyle = .fullScreen

        rootViewController.present(todoListViewController, animated: true, completion: nil)
    }
}
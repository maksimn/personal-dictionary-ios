//
//  NavigateToTodoListAppRouter.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import TodoList
import UIKit

/// Router designed for navigation to the "Todo List" application.
final class NavToTodoListRouter: Router {

    private let rootViewController: UIViewController
    private let todoListBuilder: ViewControllerBuilder

    /// - Parameters:
    ///   - rootViewController: view controller of the screen from which navigation to the "Todo List" begins.
    ///   - todoListBuilder: builder of the TodoList application.
    init(rootViewController: UIViewController,
         todoListBuilder: ViewControllerBuilder) {
        self.rootViewController = rootViewController
        self.todoListBuilder = todoListBuilder
    }

    /// Navigate to the "Todo List" application.
    func navigate() {
        let todoListViewController = todoListBuilder.build()

        todoListViewController.modalPresentationStyle = .popover

        rootViewController.present(todoListViewController, animated: true, completion: nil)
    }
}

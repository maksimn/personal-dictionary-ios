//
//  TodoListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

final class TodoListAppImpl: TodoListApp {

    private let todoListViewController: TodoListViewController

    init(routingButtonTitle: String) {
        todoListViewController = TodoListViewController(routingButtonTitle: routingButtonTitle)
    }

    var viewController: UIViewController {
        todoListViewController
    }
}

//
//  TodoListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import UIKit

final class TodoListAppImpl: TodoListApp {

    private let superAppRoutingButtonTitle: String

    private lazy var todoListViewController = TodoListViewController(
        superAppRoutingButtonTitle: superAppRoutingButtonTitle
    )

    init(superAppRoutingButtonTitle: String) {
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
    }

    var viewController: UIViewController {
        todoListViewController
    }
}

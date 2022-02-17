//
//  TodoListAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule
import UIKit

final class TodoListAppImpl: TodoListApp {

    init() {
        let todoListServiceGraph = TodoListServiceGraphOne(
            todoListCache: MOTodoListCache.instance,
            coreService: URLSessionCoreService(),
            logger: LoggerImpl(isLoggingEnabled: true),
            todoCoder: JSONCoderImpl(),
            notificationCenter: NotificationCenter.default
        )
        let todoListMVP = TodoListMVPGraph(todoListServiceGraph.service)
        guard let todoListViewController = todoListMVP.viewController else { return }

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([todoListViewController], animated: false)
    }

    let navigationController = UINavigationController()
}

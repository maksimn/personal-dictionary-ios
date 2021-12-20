//
//  ServiceGraph.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 15.07.2021.
//

import Foundation

final class TodoListServiceGraphOne: TodoListServiceGraph {

    let service: TodoListService

    init(todoListCache: TodoListCache,
         coreService: CoreService,
         logger: Logger,
         todoCoder: TodoCoder,
         notificationCenter: NotificationCenter) {
        let httpRequestCounter: HttpRequestCounter = HttpRequestCounterOne(notificationCenter)
        let networkingService: NetworkingService = DefaultNetworkingService(coreService, todoCoder)

        todoListCache.setLogger(logger)

        service = TodoListServiceOne(cache: todoListCache,
                                     logger: logger,
                                     networking: networkingService,
                                     сounter: httpRequestCounter)

    }
}

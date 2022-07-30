//
//  ServiceGraph.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 15.07.2021.
//

import CoreModule
import Foundation

final class TodoListServiceGraphOne: TodoListServiceGraph {

    let service: TodoListService

    init(todoListCache: TodoListCache,
         coreService: CoreService,
         logger: Logger,
         todoCoder: JsonCoder) {
        todoListCache.setLogger(logger)

        service = TodoListServiceOne(
            cache: todoListCache,
            logger: logger,
            networking: DefaultNetworkingService(coreService, todoCoder),
            сounter: HttpRequestCounterOne(
                httpRequestCounterPublisher: HttpRequestCounterStreamImp.instance
            ),
            mergeItemsWithRemotePublisher: MergeItemsWithRemoteStreamImp.instance
        )
    }
}

//
//  CounterBuilderImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import UIKit
import CoreModule

final class CounterBuilderImp: CounterBuilder {

    func build() -> CounterGraph {
        let logger = SLoggerImp(category: "TodoList.Counter")
        let todoListCache = TodoListCacheImp(
            container: TodoListPersistentContainer(logger: logger),
            logger: logger
        )

        return CounterGraphImp(initialCount: todoListCache.completedItemCount)
    }
}

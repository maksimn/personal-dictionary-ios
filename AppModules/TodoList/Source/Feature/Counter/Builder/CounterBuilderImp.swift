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
        CounterGraphImp(
            initialCount: MOTodoListCache(logger: LoggerImpl(isLoggingEnabled: true)).completedItemCount
        )
    }
}

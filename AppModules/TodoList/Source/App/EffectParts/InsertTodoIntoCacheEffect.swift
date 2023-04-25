//
//  InsertTodoIntoCacheEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct InsertTodoIntoCacheEffect: AsyncTodoEffect {

    let cache: TodoListCache
    let logger: Logger

    func run(todo: Todo) async throws {
        do {
            logger.logWithContext("INSERT TODO INTO CACHE START: \(todo)")
            try await cache.insert(todo)
            logger.logWithContext("INSERT TODO INTO CACHE SUCCESS: \(todo)")
        } catch {
            logger.logWithContext("INSERT TODO INTO CACHE ERROR: \(error)" , level: .error)
            throw error
        }
    }
}

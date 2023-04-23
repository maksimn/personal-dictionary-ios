//
//  UpdateTodoInCacheEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct UpdateTodoInCacheEffect: AsyncTodoEffect {

    let cache: TodoListCache
    let logger: Logger

    func run(todo: Todo) async throws {
        do {
            logger.logWithContext("UPDATE TODO IN CACHE START: \(todo)")
            try await cache.update(todo)
            logger.logWithContext("UPDATE TODO IN CACHE SUCCESS: \(todo)")
        } catch {
            logger.logWithContext("UPDATE TODO IN CACHE ERROR: \(error)", level: .error)
            throw error
        }
    }
}

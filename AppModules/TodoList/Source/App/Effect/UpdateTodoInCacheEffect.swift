//
//  UpdateTodoInCacheEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct UpdateTodoInCacheEffect: CachedTodoEffect {

    let cache: TodoListCache
    let logger: Logger
    let syncEffect: SyncEffect

    private let updateTodoInCacheStart = "UPDATE TODO IN CACHE START: "
    private let updateTodoInCacheSuccess = "UPDATE TODO IN CACHE SUCCESS: "
    private let updateTodoInCacheError = "UPDATE TODO IN CACHE ERROR: "

    func run(todo: Todo, shouldSync: Bool, _ send: Send<App.Action>) async throws {
        do {
            logger.logWithContext(updateTodoInCacheStart + todo.description)
            try await cache.update(todo)
            logger.logWithContext(updateTodoInCacheSuccess + todo.description)

            if shouldSync {
                await syncEffect.sync(send)
            }
        } catch {
            logger.logWithContext(updateTodoInCacheError + error.localizedDescription, level: .error)
            throw error
        }
    }
}

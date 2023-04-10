//
//  InsertTodoIntoCacheEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct InsertTodoIntoCacheEffect: CachedTodoEffect {

    let cache: TodoListCache
    let logger: Logger
    let syncEffect: SyncEffect

    private let insertTodoIntoCacheStart = "INSERT TODO INTO CACHE START: "
    private let insertTodoIntoCacheSuccess = "INSERT TODO INTO CACHE SUCCESS: "
    private let insertTodoIntoCacheError = "INSERT TODO INTO CACHE ERROR: "

    func run(todo: Todo, shouldSync: Bool, _ send: Send<App.Action>) async throws {
        do {
            logger.logWithContext(insertTodoIntoCacheStart + todo.description)
            try await cache.insert(todo)
            logger.logWithContext(insertTodoIntoCacheSuccess + todo.description)

            if shouldSync {
                await syncEffect.sync(send)
            }
        } catch {
            logger.logWithContext(insertTodoIntoCacheError + error.localizedDescription, level: .error)
            throw error
        }
    }
}

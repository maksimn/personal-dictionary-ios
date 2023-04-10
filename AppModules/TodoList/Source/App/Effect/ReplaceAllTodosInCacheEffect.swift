//
//  ReplaceAllTodosInCacheEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import CoreModule

struct ReplaceAllTodosInCacheEffect: TodoListEffect {

    let cache: TodoListCache
    let logger: Logger

    private let replaceAllTodosInCacheStart = "REPLACE ALL TODOS IN CACHE START"
    private let replaceAllTodosInCacheSuccess = "REPLACE ALL TODOS IN CACHE SUCCESS"
    private let replaceAllTodosInCacheError = "REPLACE ALL TODOS IN CACHE ERROR: "

    func run(todoList: [Todo]) -> AppEffectTask {
        .run { send in
            logger.logWithContext(replaceAllTodosInCacheStart)

            do {
                try await cache.replaceWith(todoList)

                logger.logWithContext(replaceAllTodosInCacheSuccess)
            } catch {
                logger.logWithContext(replaceAllTodosInCacheError + error.localizedDescription, level: .error)
            }
        }
    }
}

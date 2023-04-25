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

    func run(todoList: [Todo]) -> AppEffectTask {
        .run { send in
            logger.logWithContext("REPLACE ALL TODOS IN CACHE START")

            do {
                try await cache.replaceWith(todoList)

                logger.logWithContext("REPLACE ALL TODOS IN CACHE SUCCESS")
            } catch {
                logger.logWithContext("REPLACE ALL TODOS IN CACHE ERROR: \(error)", level: .error)
            }
        }
    }
}

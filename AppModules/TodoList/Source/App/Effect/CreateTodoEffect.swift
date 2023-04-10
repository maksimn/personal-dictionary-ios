//
//  CreateTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import CoreModule

struct CreateTodoEffect: TodoEffect {

    let cache: TodoListCache
    let service: TodoListService
    let insertTodoIntoCacheEffect: CachedTodoEffect
    let updateTodoInCacheEffect: CachedTodoEffect
    let logger: Logger

    private let createRemoteTodoStart = "CREATE REMOTE TODO START: "
    private let createRemoteTodoSuccess = "CREATE REMOTE TODO SUCCESS: "
    private let createRemoteTodoError = "CREATE REMOTE TODO ERROR: "

    func run(todo: Todo) -> AppEffectTask {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                try await insertTodoIntoCacheEffect.run(todo: dirtyTodo, shouldSync: true, send)
                return
            }

            try await insertTodoIntoCacheEffect.run(todo: dirtyTodo, shouldSync: false, send)

            do {
                await send(.networkIndicator(.incrementNetworkRequestCount))
                logger.logWithContext(createRemoteTodoStart + todo.description)
                try await service.createRemote(todo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(createRemoteTodoSuccess + todo.description)
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(createRemoteTodoError + error.localizedDescription, level: .error)

                return
            }

            try await updateTodoInCacheEffect.run(todo: todo, shouldSync: false, send)
        }
    }
}

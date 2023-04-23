//
//  CreateTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct CreateTodoEffect: TodoEffect {

    let cache: TodoListCache
    let service: TodoListService
    let insertTodoIntoCacheEffect: AsyncTodoEffect
    let updateTodoInCacheEffect: AsyncTodoEffect
    let syncEffect: SyncEffect
    let logger: Logger

    func run(todo: Todo) -> AppEffectTask {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)
            let cleanTodo = todo.update(isDirty: false)

            if cache.isDirty {
                try await insertTodoIntoCacheEffect.run(todo: dirtyTodo)
                return await syncEffect.run(send)
            }

            try await insertTodoIntoCacheEffect.run(todo: dirtyTodo)
            try await createRemote(todo: cleanTodo, send)
            try await updateTodoInCacheEffect.run(todo: cleanTodo)
        }
    }

    private func createRemote(todo: Todo, _ send: Send<App.Action>) async throws {
        do {
            logger.logWithContext("CREATE REMOTE TODO START: \(todo)")

            await send(.networkIndicator(.incrementNetworkRequestCount))
            try await service.createRemote(todo)
            await send(.networkIndicator(.decrementNetworkRequestCount))

            logger.logWithContext("CREATE REMOTE TODO SUCCESS: \(todo)")
        } catch {
            logger.logWithContext("CREATE REMOTE TODO ERROR: \(error)\t TODO: \(todo)", level: .error)

            await send(.networkIndicator(.decrementNetworkRequestCount))
            throw error
        }
    }
}

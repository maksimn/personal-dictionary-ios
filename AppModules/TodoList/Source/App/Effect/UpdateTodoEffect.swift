//
//  UpdateTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule

struct UpdateTodoEffect: TodoEffect {

    let cache: TodoListCache
    let service: TodoListService
    let updateTodoInCacheEffect: AsyncTodoEffect
    let syncEffect: SyncEffect
    let logger: Logger

    func run(todo: Todo) -> AppEffectTask {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)
            let cleanTodo = todo.update(isDirty: false)

            if cache.isDirty {
                try await updateTodoInCacheEffect.run(todo: dirtyTodo)
                return await syncEffect.run(send)
            }

            try await updateTodoInCacheEffect.run(todo: dirtyTodo)
            try await updateRemote(todo: cleanTodo, send)
            try await updateTodoInCacheEffect.run(todo: cleanTodo)
        }
    }

    private func updateRemote(todo: Todo, _ send: Send<App.Action>) async throws {
        do {
            await send(.networkIndicator(.incrementNetworkRequestCount))
            logger.logWithContext("UPDATE REMOTE TODO START: \(todo)")
            try await service.updateRemote(todo)
            await send(.networkIndicator(.decrementNetworkRequestCount))
            logger.logWithContext("UPDATE REMOTE TODO SUCCESS: \(todo)")
        } catch {
            await send(.networkIndicator(.decrementNetworkRequestCount))
            logger.logWithContext("UPDATE REMOTE TODO ERROR: \(error)\t \(todo)", level: .error)

            throw error
        }
    }
}

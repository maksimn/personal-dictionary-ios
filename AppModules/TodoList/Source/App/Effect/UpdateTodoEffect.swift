//
//  UpdateTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import CoreModule

struct UpdateTodoEffect: TodoEffect {

    let cache: TodoListCache
    let service: TodoListService
    let updateTodoInCacheEffect: CachedTodoEffect
    let logger: Logger

    private let updateRemoteTodoStart = "UPDATE REMOTE TODO START: "
    private let updateRemoteTodoSuccess = "UPDATE REMOTE TODO SUCCESS: "
    private let updateRemoteTodoError = "UPDATE REMOTE TODO ERROR: "

    func run(todo: Todo) -> AppEffectTask {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                try await updateTodoInCacheEffect.run(todo: dirtyTodo, shouldSync: true, send)
                return
            }

            try await updateTodoInCacheEffect.run(todo: dirtyTodo, shouldSync: false, send)

            do {
                await send(.networkIndicator(.incrementNetworkRequestCount))
                logger.logWithContext(updateRemoteTodoStart + todo.description)
                try await service.updateRemote(todo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(updateRemoteTodoSuccess + todo.description)
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(updateRemoteTodoError + error.localizedDescription, level: .error)

                return
            }

            try await updateTodoInCacheEffect.run(todo: todo, shouldSync: false, send)
        }
    }
}

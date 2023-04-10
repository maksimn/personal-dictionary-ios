//
//  SyncWithRemoteTodosEffect..swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture

struct SyncWithRemoteTodosEffect: SyncEffect {

    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService

    func sync(_ send: Send<App.Action>) async {
        let deleted = Array(Set(deadCache.items.map { $0.todoId }))
        let dirtyTodos = cache.todos.filter { $0.isDirty }

        await send(.syncWithRemoteTodosStart)

        do {
            await send(.networkIndicator(.incrementNetworkRequestCount))
            let todos = try await service.syncWithRemote(deleted, dirtyTodos)

            try await deadCache.clear()
            await send(.syncWithRemoteTodosSuccess(todos: todos))
        } catch {
            await send(.syncWithRemoteTodosError(error))
        }

        await send(.networkIndicator(.decrementNetworkRequestCount))
    }
}

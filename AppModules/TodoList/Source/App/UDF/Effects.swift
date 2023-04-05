//
//  MainListEffects.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 06.02.2023.
//

import ComposableArchitecture
import Foundation

protocol Effects {

    func loadCachedTodos() -> EffectTask<App.Action>

    func getRemoteTodos() -> EffectTask<App.Action>

    func replaceAllTodosInCache(todos: [Todo]) -> EffectTask<App.Action>

    func create(todo: Todo) -> EffectTask<App.Action>

    func update(todo: Todo) -> EffectTask<App.Action>

    func delete(todo: Todo) -> EffectTask<App.Action>
}

struct EffectsImp: Effects {

    private let cache: TodoListCache
    private let deadCache: DeadCache
    private let service: TodoListService
    private let logger: Logger

    init(cache: TodoListCache, deadCache: DeadCache, service: TodoListService, logger: Logger) {
        self.cache = cache
        self.deadCache = deadCache
        self.service = service
        self.logger = logger
    }

    func loadCachedTodos() -> EffectTask<App.Action> {
        .task {
            .cachedTodosLoaded(todos: cache.todos)
        }
    }

    func getRemoteTodos() -> EffectTask<App.Action> {
        .run { send in
            if cache.isDirty {
                await syncWithRemote(send)
                return
            }

            await send(.getRemoteTodosStart)
            await send(.networkIndicator(.incrementNetworkRequestCount))

            do {
                let todos = try await service.getTodos()

                await send(.getRemoteTodosSuccess(todos: todos))
            } catch {
                await send(.getRemoteTodosError(error))
            }

            await send(.networkIndicator(.decrementNetworkRequestCount))
        }
    }

    func replaceAllTodosInCache(todos: [Todo]) -> EffectTask<App.Action> {
        .run { send in
            await send(.log(.replaceAllTodosInCacheStart))

            do {
                try await cache.replaceWith(todos)
                await send(.log(.replaceAllTodosInCacheSuccess))
            } catch {
                await send(.log(.replaceAllTodosInCacheError(error)))
            }
        }
    }

    func create(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                do {
                    await send(.log(.insertTodoIntoCacheStart(dirtyTodo)))
                    try await cache.insert(dirtyTodo)
                    await send(.log(.insertTodoIntoCacheSuccess(dirtyTodo)))
                    await syncWithRemote(send)
                } catch {
                    await send(.log(.insertTodoIntoCacheError(dirtyTodo, error)))
                }

                return
            }

            do {
                await send(.log(.insertTodoIntoCacheStart(dirtyTodo)))
                try await cache.insert(dirtyTodo)
                await send(.log(.insertTodoIntoCacheSuccess(dirtyTodo)))

                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.log(.createRemoteTodoStart(todo)))
                try await service.createRemote(todo)
                await send(.log(.createRemoteTodoSuccess(todo)))

                await send(.log(.updateTodoInCacheStart(todo)))
                try await cache.update(todo)
                await send(.log(.updateTodoInCacheSuccess(todo)))
            } catch TodoListCacheError.insertFailed(let error) {
                await send(.log(.insertTodoIntoCacheError(dirtyTodo, error)))
            } catch TodoListServiceError.createFailed(let error) {
                await send(.log(.createRemoteTodoError(todo, error)))
            } catch TodoListCacheError.updateFailed(let error) {
                await send(.log(.updateTodoInCacheError(todo, error)))
            } catch {
                logger.log(error: error)
            }

            await send(.networkIndicator(.decrementNetworkRequestCount))
        }
    }

    func update(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                do {
                    await send(.log(.updateTodoInCacheStart(dirtyTodo)))
                    try await cache.update(dirtyTodo)
                    await send(.log(.updateTodoInCacheSuccess(dirtyTodo)))
                    await syncWithRemote(send)
                } catch {
                    await send(.log(.updateTodoInCacheError(dirtyTodo, error)))
                }

                return
            }

            do {
                await send(.log(.updateTodoInCacheStart(dirtyTodo)))
                try await cache.update(dirtyTodo)
                await send(.log(.updateTodoInCacheSuccess(dirtyTodo)))

                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.log(.updateRemoteTodoStart(todo)))
                try await service.updateRemote(todo)
                await send(.log(.updateRemoteTodoSuccess(todo)))

                await send(.log(.updateTodoInCacheStart(todo)))
                try await cache.update(todo)
                await send(.log(.updateTodoInCacheSuccess(todo)))
            } catch TodoListServiceError.updateFailed(let error) {
                await send(.log(.updateRemoteTodoError(todo, error)))
            } catch TodoListCacheError.updateFailed(let error) {
                await send(.log(.updateTodoInCacheError(todo, error)))
            } catch {
                logger.log(error: error)
            }

            await send(.networkIndicator(.decrementNetworkRequestCount))
        }
    }

    func delete(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            do {
                await send(.log(.deleteTodoInCacheStart(todo)))
                try await cache.delete(todo)
                await send(.log(.deleteTodoInCacheSuccess(todo)))

                if cache.isDirty {
                    let tombstone = Tombstone(todoId: todo.id, deletedAt: Date())

                    try await deadCache.insert(tombstone)
                    await syncWithRemote(send)

                    return
                }

                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.log(.deleteRemoteTodoStart(todo)))
                try await service.deleteRemote(todo)
                await send(.log(.deleteRemoteTodoSuccess(todo)))
            } catch TodoListCacheError.deleteFailed(let error) {
                await send(.log(.deleteTodoInCacheError(todo, error)))
                try await createTombstone(for: todo)
            } catch TodoListServiceError.deleteFailed(let error) {
                await send(.log(.deleteRemoteTodoError(todo, error)))
                try await createTombstone(for: todo)
            } catch {
                logger.log(error: error)
                try await createTombstone(for: todo)
            }

            await send(.networkIndicator(.decrementNetworkRequestCount))
        }
    }

    private func createTombstone(for todo: Todo) async throws {
        try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: Date()))
    }

    private func syncWithRemote(_ send: Send<App.Action>) async {
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

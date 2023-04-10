//
//  MainListEffects.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 06.02.2023.
//

import ComposableArchitecture
import CoreModule
import Foundation

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
            logger.logWithContext(replaceAllTodosInCacheStart)

            do {
                try await cache.replaceWith(todos)

                logger.logWithContext(replaceAllTodosInCacheSuccess)
            } catch {
                logger.logWithContext(replaceAllTodosInCacheError, level: .error)
                logger.errorWithContext(error)
            }
        }
    }

    func create(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                try await insertIntoCache(todo: dirtyTodo, shouldSync: true, send)
                return
            }

            try await insertIntoCache(todo: dirtyTodo, shouldSync: false, send)

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

            try await updateInCache(todo: todo, shouldSync: false, send)
        }
    }

    func update(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                try await updateInCache(todo: dirtyTodo, shouldSync: true, send)
                return
            }

            try await updateInCache(todo: dirtyTodo, shouldSync: false, send)

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

            try await updateInCache(todo: todo, shouldSync: false, send)
        }
    }

    func delete(todo: Todo) -> EffectTask<App.Action> {
        .run { send in
            do {
                logger.logWithContext(deleteTodoFromCacheStart + todo.description)
                try await cache.delete(todo)
                logger.logWithContext(deleteRemoteTodoSuccess + todo.description)
            } catch {
                logger.logWithContext(deleteRemoteTodoError + error.localizedDescription, level: .error)
                throw error
            }

            do {
                if cache.isDirty {
                    let tombstone = Tombstone(todoId: todo.id, deletedAt: Date())

                    try await deadCache.insert(tombstone)
                    await syncWithRemote(send)

                    return
                }

                await send(.networkIndicator(.incrementNetworkRequestCount))
                logger.logWithContext(deleteRemoteTodoStart + todo.description)
                try await service.deleteRemote(todo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(deleteRemoteTodoSuccess + todo.description)
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                logger.logWithContext(deleteRemoteTodoError + error.localizedDescription, level: .error)
            }

            try await createTombstone(for: todo)
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

    private func insertIntoCache(todo: Todo, shouldSync: Bool, _ send: Send<App.Action>) async throws {
        do {
            logger.logWithContext(insertTodoIntoCacheStart + todo.description)
            try await cache.insert(todo)
            logger.logWithContext(insertTodoIntoCacheSuccess + todo.description)

            if shouldSync {
                await syncWithRemote(send)
            }
        } catch {
            logger.logWithContext(insertTodoIntoCacheError + error.localizedDescription, level: .error)
            throw error
        }
    }

    private func updateInCache(todo: Todo, shouldSync: Bool, _ send: Send<App.Action>) async throws {
        do {
            logger.logWithContext(updateTodoInCacheStart + todo.description)
            try await cache.update(todo)
            logger.logWithContext(updateTodoInCacheSuccess + todo.description)

            if shouldSync {
                await syncWithRemote(send)
            }
        } catch {
            logger.logWithContext(updateTodoInCacheError + error.localizedDescription, level: .error)
            throw error
        }
    }
}

private let replaceAllTodosInCacheStart = "REPLACE ALL TODOS IN CACHE START"
private let replaceAllTodosInCacheSuccess = "REPLACE ALL TODOS IN CACHE SUCCESS"
private let replaceAllTodosInCacheError = "REPLACE ALL TODOS IN CACHE ERROR"

private let insertTodoIntoCacheStart = "INSERT TODO INTO CACHE START: "
private let insertTodoIntoCacheSuccess = "INSERT TODO INTO CACHE SUCCESS: "
private let insertTodoIntoCacheError = "INSERT TODO INTO CACHE ERROR: "

private let updateTodoInCacheStart = "UPDATE TODO IN CACHE START: "
private let updateTodoInCacheSuccess = "UPDATE TODO IN CACHE SUCCESS: "
private let updateTodoInCacheError = "UPDATE TODO IN CACHE ERROR: "

private let deleteTodoFromCacheStart = "DELETE TODO FROM CACHE START: "
private let deleteTodoFromCacheSuccess = "DELETE TODO FROM CACHE SUCCESS: "
private let deleteTodoFromCacheError = "DELETE TODO FROM CACHE ERROR: "

private let createRemoteTodoStart = "CREATE REMOTE TODO START: "
private let createRemoteTodoSuccess = "CREATE REMOTE TODO SUCCESS: "
private let createRemoteTodoError = "CREATE REMOTE TODO ERROR: "

private let updateRemoteTodoStart = "UPDATE REMOTE TODO START: "
private let updateRemoteTodoSuccess = "UPDATE REMOTE TODO SUCCESS: "
private let updateRemoteTodoError = "UPDATE REMOTE TODO ERROR: "

private let deleteRemoteTodoStart = "DELETE REMOTE TODO START: "
private let deleteRemoteTodoSuccess = "DELETE REMOTE TODO SUCCESS: "
private let deleteRemoteTodoError = "DELETE REMOTE TODO ERROR: "

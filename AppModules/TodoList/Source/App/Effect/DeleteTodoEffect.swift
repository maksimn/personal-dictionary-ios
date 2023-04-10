//
//  DeleteTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import CoreModule
import Foundation

struct DeleteTodoEffect: TodoEffect {

    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService
    let syncEffect: SyncEffect
    let logger: Logger

    private let deleteTodoFromCacheStart = "DELETE TODO FROM CACHE START: "
    private let deleteTodoFromCacheSuccess = "DELETE TODO FROM CACHE SUCCESS: "
    private let deleteTodoFromCacheError = "DELETE TODO FROM CACHE ERROR: "

    private let deleteRemoteTodoStart = "DELETE REMOTE TODO START: "
    private let deleteRemoteTodoSuccess = "DELETE REMOTE TODO SUCCESS: "
    private let deleteRemoteTodoError = "DELETE REMOTE TODO ERROR: "

    func run(todo: Todo) -> AppEffectTask {
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
                    await syncEffect.sync(send)

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
}

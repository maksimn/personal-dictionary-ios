//
//  DeleteTodoEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture
import CoreModule
import Foundation

struct DeleteTodoEffect: TodoEffect {

    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService
    let syncEffect: SyncEffect
    let logger: Logger

    func run(todo: Todo) -> AppEffectTask {
        .run { send in
            try await deleteFromCache(todo)
            await deleteRemote(todo, send)
        }
    }

    private func deleteFromCache(_ todo: Todo) async throws {
        do {
            logger.logWithContext("DELETE TODO FROM CACHE START: \(todo)")
            try await cache.delete(todo)
            logger.logWithContext("DELETE TODO FROM CACHE SUCCESS: \(todo)")
        } catch {
            logger.logWithContext("DELETE TODO FROM CACHE ERROR: \(error)\t \(todo)", level: .error)
            throw error
        }
    }

    private func deleteRemote(_ todo: Todo, _ send: Send<App.Action>) async {
        do {
            if cache.isDirty {
                try await createTombstone(for: todo)
                return await syncEffect.run(send)
            }

            await send(.networkIndicator(.incrementNetworkRequestCount))

            logger.logWithContext("DELETE REMOTE TODO START: \(todo)")

            try await service.deleteRemote(todo)
            await send(.networkIndicator(.decrementNetworkRequestCount))

            logger.logWithContext("DELETE REMOTE TODO SUCCESS: \(todo)")
        } catch {
            await send(.networkIndicator(.decrementNetworkRequestCount))

            logger.logWithContext("DELETE REMOTE TODO ERROR: \(error)\t \(todo)")
        }
    }

    private func createTombstone(for todo: Todo) async throws {
        try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: Date()))
    }
}

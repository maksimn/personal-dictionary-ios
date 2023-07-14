//
//  DirtyStateCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData

protocol TombstoneInsertable {

    func insert(_ item: Tombstone) async throws
}

protocol Clearable {

    func clear() async throws
}

struct DeletedTodoCache: TombstoneInsertable, Clearable {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func insert(_ item: Tombstone) async throws {
        try await withCheckedThrowingContinuation { continuation in
            insert(tombstone: item) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: DeletedTodoCacheError.insertError(error))
                }
            }
        }
    }

    func clear() async throws {
        try await withCheckedThrowingContinuation { continuation in
            clearTombstones { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: DeletedTodoCacheError.clearError(error))
                }
            }
        }
    }

    private func clearTombstones(_ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform {
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func insert(tombstone: Tombstone, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform {
            let tombstoneMO = TombstoneMO(entity: TombstoneMO.entity(), insertInto: backgroundContext)

            tombstoneMO.todoId = tombstone.todoId
            tombstoneMO.deletedAt = tombstone.deletedAt

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

enum DeletedTodoCacheError: Error {
    case insertError(Error)
    case clearError(Error)
}

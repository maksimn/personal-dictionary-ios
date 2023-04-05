//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData

final class DeadCacheImp: DeadCache {

    private lazy var container = TodoListPersistentContainer(logger: logger)
    private let logger: Logger

    private var mainContext: NSManagedObjectContext {
        container.persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer {
        container.persistentContainer
    }

    init(logger: Logger) {
        self.logger = logger
    }

    var items: [Tombstone] {
        let fetchRequest: NSFetchRequest<TombstoneMO> = TombstoneMO.fetchRequest()

        do {
            let tombstoneMOList = try mainContext.fetch(fetchRequest)

            return tombstoneMOList.map { tombstoneMO in
                Tombstone(todoId: tombstoneMO.todoId ?? "", deletedAt: tombstoneMO.deletedAt ?? Date())
            }
        } catch {
            logger.log(error: error)
            return []
        }
    }

    func insert(_ item: Tombstone) async throws {
        try await withCheckedThrowingContinuation { continuation in
            insert(tombstone: item) { result in
                continuation.resume(with: result)
            }
        }
    }

    func clear() async throws {
        try await withCheckedThrowingContinuation { continuation in
            clearTombstones { result in
                continuation.resume(with: result)
            }
        }
    }

    private func insert(tombstone: Tombstone, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let tombstoneMO = TombstoneMO(entity: TombstoneMO.entity(), insertInto: backgroundContext)

            tombstoneMO.todoId = tombstone.todoId
            tombstoneMO.deletedAt = tombstone.deletedAt

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func clearTombstones(_ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

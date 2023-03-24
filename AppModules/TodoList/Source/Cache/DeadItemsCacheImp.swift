//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData
import CoreModule

final class DeadItemsCacheImp: DeadItemsCache {

    private let container: TodoListPersistentContainer
    private let logger: Logger

    private var mainContext: NSManagedObjectContext {
        container.persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer {
        container.persistentContainer
    }

    init(container: TodoListPersistentContainer,
         logger: Logger) {
        self.container = container
        self.logger = logger
    }

    var tombstones: [Tombstone] {
        let fetchRequest: NSFetchRequest<TombstoneMO> = TombstoneMO.fetchRequest()

        do {
            let tombstoneMOList = try mainContext.fetch(fetchRequest)

            return tombstoneMOList.map { tombstoneMO in
                Tombstone(itemId: tombstoneMO.itemId ?? "", deletedAt: tombstoneMO.deletedAt ?? Date())
            }
        } catch {
            logger.log("\(error)")
            return []
        }
    }

    func insert(tombstone: Tombstone, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let tombstoneMO = TombstoneMO(entity: TombstoneMO.entity(), insertInto: backgroundContext)

            tombstoneMO.itemId = tombstone.itemId
            tombstoneMO.deletedAt = tombstone.deletedAt

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func clearTombstones(_ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}

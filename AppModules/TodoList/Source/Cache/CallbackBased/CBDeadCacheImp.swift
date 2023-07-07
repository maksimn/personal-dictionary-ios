//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData

final class CBDeadCacheImp: CBDeadCache {

    private let persistentContainer: NSPersistentContainer

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    var items: [Tombstone] {
        get throws {
            let fetchRequest: NSFetchRequest<TombstoneMO> = TombstoneMO.fetchRequest()
            let tombstoneMOList = try mainContext.fetch(fetchRequest)

            return tombstoneMOList.map { tombstoneMO in
                Tombstone(todoId: tombstoneMO.todoId ?? "", deletedAt: tombstoneMO.deletedAt ?? Date())
            }
        }
    }

    func insert(tombstone: Tombstone, _ completion: @escaping VoidCallback) {
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

    func clear(_ completion: @escaping VoidCallback) {
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
}

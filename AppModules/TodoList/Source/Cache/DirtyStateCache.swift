//
//  DirtyStateCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData

protocol DirtyStateCache {

    var dirtyData: DirtyData { get throws }
}

struct DirtyStateCacheImp: DirtyStateCache {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    var dirtyData: DirtyData {
        get throws {
            .init(
                dirtyTodos: try dirtyTodos,
                tombstones: try tombstones
            )
        }
    }

    private var dirtyTodos: [Todo] {
        get throws {
            let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

            fetchRequest.predicate = NSPredicate(format: "isDirty == true")

            let todoMOList = try persistentContainer.viewContext.fetch(fetchRequest)

            return todoMOList.map { $0.todo }
        }
    }

    private var tombstones: [Tombstone] {
        get throws {
            let fetchRequest: NSFetchRequest<TombstoneMO> = TombstoneMO.fetchRequest()
            let tombstoneMOList = try persistentContainer.viewContext.fetch(fetchRequest)

            return tombstoneMOList.map { tombstoneMO in
                Tombstone(todoId: tombstoneMO.todoId ?? "", deletedAt: tombstoneMO.deletedAt ?? Date())
            }
        }
    }
}

//
//  DirtyStateStatus.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2023.
//

import CoreData

protocol DirtyStateStatus {

    var isDirty: Bool { get }
}

struct DirtyStateStatusImp: DirtyStateStatus {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    var isDirty: Bool {
        !(areTombstonesEmpty && areDirtyTodosEmpty)
    }

    private var areTombstonesEmpty: Bool {
        let tombstonesRequest = TombstoneMO.fetchRequest()

        tombstonesRequest.fetchLimit = 1

        return ((try? persistentContainer.viewContext.fetch(tombstonesRequest)) ?? []).isEmpty
    }

    private var areDirtyTodosEmpty: Bool {
        let dirtyTodoRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

        dirtyTodoRequest.predicate = NSPredicate(format: "isDirty == true")
        dirtyTodoRequest.fetchLimit = 1

        return ((try? persistentContainer.viewContext.fetch(dirtyTodoRequest)) ?? []).isEmpty
    }
}

//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData
import CoreModule

protocol PersistentContainerFactory {

    func persistentContainer() -> NSPersistentContainer
}

struct PersistentContainerFactoryImp: PersistentContainerFactory {

    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func persistentContainer() -> NSPersistentContainer {
        let bundle = Bundle.module
        let persistentContainerName = "TodoList"

        guard let modelURL = bundle.url(forResource: persistentContainerName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSPersistentContainer()
        }

        let container = NSPersistentContainer(name: persistentContainerName,
                                              managedObjectModel: managedObjectModel)

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            if let error = error {
                self.logger.errorWithContext(error)
            }
        })
        return container
    }
}

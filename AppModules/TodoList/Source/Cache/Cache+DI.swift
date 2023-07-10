//
//  Cache+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

import CoreData
import CoreModule

extension TodoListCacheImp {
    init(label: String) {
        self.init(cbTodoListCache: CBTodoListCacheImp(persistentContainer: persistentContainer(label)))
    }
}

extension DeadCacheImp {
    init(label: String) {
        self.init(cbDeadCache: CBDeadCacheImp(persistentContainer: persistentContainer(label)))
    }
}

private func persistentContainer(_ label: String) -> NSPersistentContainer {
    PersistentContainerFactoryImp(logger: LoggerImpl(category: label)).persistentContainer()
}

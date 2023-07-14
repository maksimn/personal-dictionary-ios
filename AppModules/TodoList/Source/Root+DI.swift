//
//  Root+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 18.07.2023.
//

import CoreData
import CoreModule

func persistentContainer(_ label: String) -> NSPersistentContainer {
    PersistentContainerFactoryImp(logger: LoggerImpl(category: label)).persistentContainer()
}

//
//  Cache+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

extension TodoListCacheImp {
    init(label: String) {
        self.init(cbTodoListCache: CBTodoListCacheImp(persistentContainer: persistentContainer(label)))
    }
}

extension DirtyStateStatusImp {
    init(label: String) {
        self.init(persistentContainer: persistentContainer(label))
    }
}

extension DeletedTodoCache {
    init(label: String) {
        self.init(persistentContainer: persistentContainer(label))
    }
}


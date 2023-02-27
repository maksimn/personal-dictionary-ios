//
//  TodoListCacheStub.swift
//  ToDoListTests
//
//  Created by Maxim Ivanov on 22.07.2021.
//

import CoreModule
@testable import TodoList

class TodoListCacheStub: TodoListCache {
    var completedItemCount: Int = 0

    var isDirty: Bool = false

    var items: [TodoItem] = []

    func insert(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func update(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func delete(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func replaceWith(_ todoList: [TodoItem], _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

}

class DeadItemsCacheStub: DeadItemsCache {

    var tombstones: [Tombstone] = []

    func insert(tombstone: Tombstone, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func clearTombstones(_ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
}

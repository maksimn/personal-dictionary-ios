//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreModule

protocol TodoListCache {

    var isDirty: Bool { get }

    var todoList: [TodoItem] { get }

    var tombstones: [Tombstone] { get }

    func insert(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func update(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func delete(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func insert(tombstone: Tombstone, _ completion: @escaping (Error?) -> Void)

    func clearTombstones(_ completion: @escaping (Error?) -> Void)

    func replaceWith(_ todoList: [TodoItem], _ completion: @escaping (Error?) -> Void)

    func setLogger(_ logger: Logger)
}

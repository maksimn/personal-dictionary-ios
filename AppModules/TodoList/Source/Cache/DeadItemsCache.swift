//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol DeadItemsCache {

    var tombstones: [Tombstone] { get }

    func insert(tombstone: Tombstone, _ completion: @escaping (Error?) -> Void)

    func clearTombstones(_ completion: @escaping (Error?) -> Void)
}

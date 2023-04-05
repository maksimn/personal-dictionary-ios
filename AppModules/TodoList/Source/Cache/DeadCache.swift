//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol DeadCache {

    var items: [Tombstone] { get }

    func insert(_ item: Tombstone) async throws

    func clear() async throws
}

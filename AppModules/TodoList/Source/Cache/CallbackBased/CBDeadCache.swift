//
//  CBDeadCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2023.
//

protocol CBDeadCache {

    var isEmpty: Bool { get }

    var items: [Tombstone] { get throws }

    func insert(tombstone: Tombstone, _ completion: @escaping VoidCallback)

    func clear(_ completion: @escaping VoidCallback)
}

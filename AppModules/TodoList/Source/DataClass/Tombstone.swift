//
//  Tombstone.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

struct Tombstone: Codable {

    init(itemId: String, deletedAt: Date) {
        self.itemId = itemId
        self.deletedAt = deletedAt
    }

    let itemId: String
    let deletedAt: Date
}

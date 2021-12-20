//
//  Tombstone.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

public struct Tombstone: Codable {

    public init(itemId: String, deletedAt: Date) {
        self.itemId = itemId
        self.deletedAt = deletedAt
    }

    public let itemId: String
    public let deletedAt: Date
}

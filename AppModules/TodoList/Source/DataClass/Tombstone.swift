//
//  Tombstone.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

struct Tombstone: Codable, Equatable {

    let todoId: String
    let deletedAt: Date
}

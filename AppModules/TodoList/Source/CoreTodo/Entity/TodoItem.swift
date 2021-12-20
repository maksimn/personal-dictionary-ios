//
//  TodoItem.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.06.2021.
//

import Foundation

public enum TodoItemPriority: String, Codable {
    case high
    case normal
    case low
}

public struct TodoItem: Equatable, Codable {

    public let id: String
    public let text: String
    public let priority: TodoItemPriority
    public let deadline: Date?
    public let isCompleted: Bool
    public let createdAt: Int
    public let updatedAt: Int
    public let isDirty: Bool

    public init(id: String = UUID().uuidString,
                text: String,
                priority: TodoItemPriority = .normal,
                deadline: Date? = nil,
                isCompleted: Bool = false,
                createdAt: Int? = nil,
                updatedAt: Int? = nil,
                isDirty: Bool = false) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.isDirty = isDirty
        let now = Date()
        self.createdAt = createdAt ?? now.integer
        self.updatedAt = updatedAt ?? now.integer
    }

    public func update(text: String? = nil,
                       priority: TodoItemPriority? = nil,
                       deadline: Date? = nil,
                       isCompleted: Bool? = nil,
                       updatedAt: Int = Date().integer,
                       isDirty: Bool? = nil) -> TodoItem {
        TodoItem(id: self.id,
                 text: text ?? self.text,
                 priority: priority ?? self.priority,
                 deadline: deadline ?? self.deadline,
                 isCompleted: isCompleted ?? self.isCompleted,
                 createdAt: self.createdAt,
                 updatedAt: updatedAt,
                 isDirty: isDirty ?? self.isDirty)
    }

    public static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.text == rhs.text &&
            lhs.priority == rhs.priority &&
            lhs.deadline?.timeIntervalSince1970 == rhs.deadline?.timeIntervalSince1970 &&
            lhs.isCompleted == rhs.isCompleted &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.isDirty == rhs.isDirty
    }
}

//
//  TodoItemDTO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

public struct TodoItemDTO: Codable {

    public let id: String
    public let text: String
    public let importance: String
    public let done: Bool
    public let deadline: Int?
    public let createdAt: Int
    public let updatedAt: Int

    private enum CodingKeys: String, CodingKey {
        case id,
             text,
             importance,
             done,
             deadline,
             createdAt = "created_at",
             updatedAt = "updated_at"
    }

    public static func map(_ item: TodoItem) -> TodoItemDTO {
        var deadlineInteger: Int?

        if let deadline = item.deadline {
            deadlineInteger = Int(deadline.timeIntervalSince1970)
        }

        return TodoItemDTO(id: item.id,
                           text: item.text,
                           importance: mapPriority(item.priority),
                           done: item.isCompleted,
                           deadline: deadlineInteger,
                           createdAt: item.createdAt,
                           updatedAt: item.updatedAt)
    }

    public func map() -> TodoItem {
        var deadlineDate: Date?

        if let deadline = deadline {
            deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline))
        }

        return TodoItem(id: id,
                        text: text,
                        priority: TodoItemDTO.mapPriority(importance),
                        deadline: deadlineDate,
                        isCompleted: done,
                        createdAt: createdAt,
                        updatedAt: updatedAt)
    }

    public static func mapPriority(_ string: String) -> TodoItemPriority {
        switch string {
        case "low":
            return .low
        case "important":
            return .high
        default:
            return .normal
        }
    }

    public static func mapPriority(_ priority: TodoItemPriority) -> String {
        switch priority {
        case .high:
            return "important"
        case .low:
            return "low"
        default:
            return "basic"
        }
    }
}

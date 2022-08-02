//
//  TodoItemDTO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

protocol DTO: Codable { }

extension Array: DTO where Element == TodoItemDTO { }

struct TodoItemDTO: DTO {

    let id: String
    let text: String
    let importance: String
    let done: Bool
    let deadline: Int?
    let createdAt: Int
    let updatedAt: Int

    init(_ item: TodoItem) {
        var deadlineInteger: Int?

        if let deadline = item.deadline {
            deadlineInteger = Int(deadline.timeIntervalSince1970)
        }

        id = item.id
        text = item.text
        importance = TodoItemDTO.mapPriority(item.priority)
        done = item.isCompleted
        deadline = deadlineInteger
        createdAt = item.createdAt
        updatedAt = item.updatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case id,
             text,
             importance,
             done,
             deadline,
             createdAt = "created_at",
             updatedAt = "updated_at"
    }

    static func mapPriority(_ string: String) -> TodoItemPriority {
        switch string {
        case "low":
            return .low
        case "important":
            return .high
        default:
            return .normal
        }
    }

    static func mapPriority(_ priority: TodoItemPriority) -> String {
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

extension TodoItem {

    init(_ dto: TodoItemDTO) {
        var deadlineDate: Date?

        if let deadline = dto.deadline {
            deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline))
        }

        id = dto.id
        text =  dto.text
        priority = TodoItemDTO.mapPriority(dto.importance)
        deadline = deadlineDate
        isCompleted = dto.done
        createdAt = dto.createdAt
        updatedAt = dto.updatedAt
        isDirty = false
    }
}

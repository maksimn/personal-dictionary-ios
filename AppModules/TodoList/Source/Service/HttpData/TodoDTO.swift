//
//  TodoDTO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 29.06.2021.
//

import Foundation

struct TodoDTO: Codable {

    let id: String
    let text: String
    let importance: String
    let done: Bool
    let deadline: Int?
    let createdAt: Int
    let updatedAt: Int

    init(_ todo: Todo) {
        var deadlineInteger: Int?

        if let deadline = todo.deadline {
            deadlineInteger = Int(deadline.timeIntervalSince1970)
        }

        id = todo.id
        text = todo.text
        importance = TodoDTO.mapPriority(todo.priority)
        done = todo.isCompleted
        deadline = deadlineInteger
        createdAt = todo.createdAt
        updatedAt = todo.updatedAt
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

    static func mapPriority(_ string: String) -> TodoPriority {
        switch string {
        case "low":
            return .low
        case "important":
            return .high
        default:
            return .normal
        }
    }

    static func mapPriority(_ priority: TodoPriority) -> String {
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

extension Todo {

    init(_ dto: TodoDTO) {
        var deadlineDate: Date?

        if let deadline = dto.deadline {
            deadlineDate = Date(timeIntervalSince1970: TimeInterval(deadline))
        }

        id = dto.id
        text =  dto.text
        priority = TodoDTO.mapPriority(dto.importance)
        deadline = deadlineDate
        isCompleted = dto.done
        createdAt = dto.createdAt
        updatedAt = dto.updatedAt
        isDirty = false
    }
}

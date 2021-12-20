//
//  TodoItemPriorityMapper.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 12.06.2021.
//

class TodoItemPriorityMapper {

    func priority(for index: Int) -> TodoItemPriority {
        switch index {
        case 0:
            return .low
        case 2:
            return .high
        default:
            return .normal
        }
    }

    func index(for priority: TodoItemPriority) -> Int {
        switch priority {
        case .high:
            return 2
        case .low:
            return 0
        default:
            return 1
        }
    }
}

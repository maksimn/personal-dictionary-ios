//
//  UISegmentedControl+Core.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

import UIKit

extension UISegmentedControl {

    func setTodoItem(priority: TodoItemPriority) {
        switch priority {
        case .high:
            selectedSegmentIndex = 2
        case .low:
            selectedSegmentIndex = 0
        default:
            selectedSegmentIndex = 1
        }
    }

    var todoItemPriority: TodoItemPriority {
        switch selectedSegmentIndex {
        case 0:
            return .low
        case 2:
            return .high
        default:
            return .normal
        }
    }
}
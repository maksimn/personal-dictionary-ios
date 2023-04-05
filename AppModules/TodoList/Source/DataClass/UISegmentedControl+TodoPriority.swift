//
//  UISegmentedControl+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import UIKit

extension UISegmentedControl {

    func setTodoPriority(_ priority: TodoPriority) {
        switch priority {
        case .high:
            selectedSegmentIndex = 2
        case .low:
            selectedSegmentIndex = 0
        default:
            selectedSegmentIndex = 1
        }
    }

    var todoPriority: TodoPriority {
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

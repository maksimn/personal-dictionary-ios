//
//  Date+Core.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import Foundation

extension Date {

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"

        return dateFormatter.string(from: self)
    }

    var integer: Int {
        Int(timeIntervalSince1970)
    }
}

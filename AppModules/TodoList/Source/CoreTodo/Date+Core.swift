//
//  Date+Core.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import Foundation

extension Date {

    public var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"

        return dateFormatter.string(from: self)
    }

    public var integer: Int {
        Int(timeIntervalSince1970)
    }
}

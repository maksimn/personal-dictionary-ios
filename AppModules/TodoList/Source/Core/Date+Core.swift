//
//  Date+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import Foundation

extension Date {

    var dMMMMyyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"

        return dateFormatter.string(from: self)
    }

    var integer: Int {
        Int(timeIntervalSince1970)
    }
}

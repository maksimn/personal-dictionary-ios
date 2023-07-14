//
//  Date+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 12.08.2022.
//

import Foundation

extension Data {

    public var asUTF8: String {
        String(decoding: self, as: UTF8.self)
    }
}

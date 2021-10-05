//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

struct Lang: Equatable {

    let name: String

    static func == (lhs: Lang, rhs: Lang) -> Bool {
        return lhs.name == rhs.name
    }
}

//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

struct Lang: Equatable {

    typealias Id = Tagged<Lang, Int>

    let id: Id
    let name: String

    static func == (lhs: Lang, rhs: Lang) -> Bool {
        lhs.id.raw == lhs.id.raw
    }
}

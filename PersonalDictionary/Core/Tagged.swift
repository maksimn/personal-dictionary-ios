//
//  Tagged.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

struct Tagged<Tag, RawValue: Equatable>: Equatable {

    let raw: RawValue

    static func == (_ lhs: Tagged, _ rhs: Tagged) -> Bool {
        lhs.raw == rhs.raw
    }
}

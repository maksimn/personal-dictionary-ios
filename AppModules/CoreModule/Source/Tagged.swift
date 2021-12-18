//
//  Tagged.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

public struct Tagged<Tag, RawValue: Equatable>: Equatable {

    public let raw: RawValue

    public init(raw: RawValue) {
        self.raw = raw
    }

    public static func == (_ lhs: Tagged, _ rhs: Tagged) -> Bool {
        lhs.raw == rhs.raw
    }
}

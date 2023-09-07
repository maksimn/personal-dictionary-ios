//
//  Math.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 09.09.2023.
//

public func almostEqual<T>(_ x: T, _ y: T) -> Bool where T: Comparable, T: SignedNumeric {
    10 * abs(x - y) <= min(abs(x), abs(y))
}

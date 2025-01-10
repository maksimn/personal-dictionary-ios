//
//  WrappedOptional.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 27.06.2024.
//

/// Generic wrapper for optional value.
public struct WrappedOptional<T: Equatable>: Equatable, CustomStringConvertible {

    public var value: T?

    public init(value: T? = nil) {
        self.value = value
    }

    public var description: String {
        guard let value else { return "nil" }

        return "\(value)"
    }
}

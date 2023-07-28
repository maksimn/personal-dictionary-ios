//
//  WithError.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 29.07.2023.
//

public struct WithError: Error, Equatable, CustomStringConvertible {

    public let base: Error

    private let equals: (Error) -> Bool

    public init<Base: Error>(_ base: Base) {
        self.base = base
        self.equals = { String(reflecting: $0) == String(reflecting: base) }
    }

    public init<Base: Error & Equatable>(_ base: Base) {
        self.base = base
        self.equals = { ($0 as? Base) == base }
    }

    public static func == (lhs: WithError, rhs: WithError) -> Bool {
        lhs.equals(rhs.base)
    }

    public var description: String {
        "\(self.base)"
    }

    public func asError<Base: Error>(type: Base.Type) -> Base? {
        self.base as? Base
    }

    public var localizedDescription: String {
        self.base.localizedDescription
    }
}

extension Error where Self: Equatable {
    public func withError() -> WithError {
        WithError(self)
    }
}

extension Error {
    public func withError() -> WithError {
        WithError(self)
    }
}

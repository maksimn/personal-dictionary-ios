//
//  LocalizableStringKey.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 23.10.2023.
//

import UIKit

/*
 A type to work with locale-dependent strings.
 It accepts a string key (universal for any locale) and allows to get a localized string from module resources.
 */
public struct LocalizableStringKey: Equatable, CustomStringConvertible {

    public let key: String

    private let bundle: Bundle

    public init(_ key: String, bundle: Bundle) {
        self.key = key
        self.bundle = bundle
    }

    public static func == (_ lhs: LocalizableStringKey, _ rhs: LocalizableStringKey) -> Bool {
        lhs.key == rhs.key
    }

    public var localizedString: String {
        bundle.moduleLocalizedString(key)
    }

    public var description: String {
        "LocalizableStringKey(\(key))"
    }
}

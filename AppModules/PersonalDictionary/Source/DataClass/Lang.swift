//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

import CoreModule
import UIKit

/// A structure with data about a language.
struct Lang: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Lang, Int>
    typealias Key = Tagged<Lang, String>

    /// Language identifier
    let id: Id

    let nameKey: Key

    let shortNameKey: Key

    /// Language name
    var name: String {
        Bundle.module.moduleLocalizedString(nameKey.raw)
    }

    /// Short language name ("EN" for English, "RU" for Russian, etc.)
    var shortName: String {
        Bundle.module.moduleLocalizedString(shortNameKey.raw)
    }

    /// Equality operator for two language objects
    static func == (lhs: Lang, rhs: Lang) -> Bool {
        lhs.id == rhs.id
    }

    var description: String {
        "Lang(\(id.raw), \(shortName))"
    }

    static var empty: Lang {
        Lang(id: .init(raw: -1), nameKey: .init(raw: ""), shortNameKey: .init(raw: ""))
    }
}

/// Type of the selected language
enum LangType: String, CustomStringConvertible {
    case source /// source language
    case target /// target language

    static var defaultValue: LangType { .source }

    var description: String {
        "LangType.\(self.rawValue)"
    }
}

/// Language data in the application.
struct LangData {

    /// Array of all supported languages
    let allLangs: [Lang]

    /// Key for persistent storage of the current source language
    let sourceLangKey: String

    /// Key for persistent storage of the current target language
    let targetLangKey: String

    /// Default source language
    let defaultSourceLang: Lang

    /// Default target language
    let defaultTargetLang: Lang
}

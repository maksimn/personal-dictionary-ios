//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

/// Implementation of the language data storage in the application.
final class UDLangRepository: LangRepository {

    private let userDefaults: UserDefaults
    private let data: LangData

    /// Initializer.
    /// - Parameters:
    ///  - userDefaults: UserDefaults for storing data.
    ///  - data: language data in the application.
    init(userDefaults: UserDefaults,
         data: LangData) {
        self.userDefaults = userDefaults
        self.data = data
    }

    /// List of all languages in the application
    var allLangs: [Lang] {
        data.allLangs
    }

    /// Save and retrieve the source language
    var sourceLang: Lang {
        get {
            findLang(with: data.sourceLangKey) ?? data.defaultSourceLang
        }
        set {
            userDefaults.set(newValue.id.raw, forKey: data.sourceLangKey)
        }
    }

    /// Save and retrieve the target language
    var targetLang: Lang {
        get {
            findLang(with: data.targetLangKey) ?? data.defaultTargetLang
        }
        set {
            userDefaults.set(newValue.id.raw, forKey: data.targetLangKey)
        }
    }

    private func findLang(with key: String) -> Lang? {
        let integer = userDefaults.integer(forKey: key)

        return data.allLangs.first(where: { $0.id == Lang.Id(raw: integer) })
    }
}

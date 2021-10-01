//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

final class LangRepositoryImpl: LangRepository {

    let allLangs = [Lang(name: "Английский"),
                    Lang(name: "Русский"),
                    Lang(name: "Французский"),
                    Lang(name: "Итальянский")]

    private let userDefaults: UserDefaults

    private let sourceLangKey = Keys.userDefaultsUniquePrefix + ".sourceLang"
    private let targetLangKey = Keys.userDefaultsUniquePrefix + ".targetLang"

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var sourceLang: Lang {
        get {
            findLang(with: sourceLangKey) ?? sourceLangDefault
        }
        set {
            userDefaults.set(newValue.name, forKey: sourceLangKey)
        }
    }

    var targetLang: Lang {
        get {
            findLang(with: targetLangKey) ?? targetLangDefault
        }
        set {
            userDefaults.set(newValue.name, forKey: targetLangKey)
        }
    }

    private var sourceLangDefault: Lang {
        allLangs[0]
    }

    private var targetLangDefault: Lang {
        allLangs[1]
    }

    private func findLang(with key: String) -> Lang? {
        let langName = userDefaults.string(forKey: key)

        return allLangs.first(where: { $0.name == langName })
    }
}

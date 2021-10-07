//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

struct LangResourceData {
    let allLangs: [Lang]
    let sourceLangKey: String
    let targetLangKey: String
    let defaultSourceLang: Lang
    let defaultTargetLang: Lang
}

final class LangRepositoryImpl: LangRepository {

    let userDefaults: UserDefaults
    let data: LangResourceData

    init(userDefaults: UserDefaults,
         data: LangResourceData) {
        self.userDefaults = userDefaults
        self.data = data
    }

    var allLangs: [Lang] {
        data.allLangs
    }

    var sourceLang: Lang {
        get {
            findLang(with: data.sourceLangKey) ?? data.defaultSourceLang
        }
        set {
            userDefaults.set(newValue.id, forKey: data.sourceLangKey)
        }
    }

    var targetLang: Lang {
        get {
            findLang(with: data.targetLangKey) ?? data.defaultTargetLang
        }
        set {
            userDefaults.set(newValue.id, forKey: data.targetLangKey)
        }
    }

    private func findLang(with key: String) -> Lang? {
        let langId = userDefaults.integer(forKey: key)

        return data.allLangs.first(where: { $0.id == langId })
    }
}
//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

final class LangRepositoryImpl: LangRepository {

    let userDefaults: UserDefaults
    let data: LangData

    init(userDefaults: UserDefaults,
         data: LangData) {
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
            userDefaults.set(newValue.id.raw, forKey: data.sourceLangKey)
        }
    }

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

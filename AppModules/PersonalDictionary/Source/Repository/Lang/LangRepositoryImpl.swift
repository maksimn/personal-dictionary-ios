//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

/// Реализация хранилища данных о языках в приложении,
final class LangRepositoryImpl: LangRepository {

    private let userDefaults: UserDefaults
    private let data: LangData

    /// Инициализатор.
    /// - Parameters:
    ///  - userDefaults: UserDefaults для хранения данных в нём.
    ///  - data: данные о языках в приложении.
    init(userDefaults: UserDefaults,
         data: LangData) {
        self.userDefaults = userDefaults
        self.data = data
    }

    /// Список всех языков в приложении
    var allLangs: [Lang] {
        data.allLangs
    }

    /// Сохранить и извлечь исходный язык
    var sourceLang: Lang {
        get {
            findLang(with: data.sourceLangKey) ?? data.defaultSourceLang
        }
        set {
            userDefaults.set(newValue.id.raw, forKey: data.sourceLangKey)
        }
    }

    /// Сохранить и извлечь целевой язык
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

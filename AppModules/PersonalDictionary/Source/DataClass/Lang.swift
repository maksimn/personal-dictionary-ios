//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

import CoreModule
import UIKit

/// Структура с данными об отдельном языке.
struct Lang: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Lang, Int>
    typealias Key = Tagged<Lang, String>

    /// Идентификатор языка
    let id: Id

    let nameKey: Key

    let shortNameKey: Key

    /// Название языка
    var name: String {
        Bundle.module.moduleLocalizedString(nameKey.raw)
    }

    /// Короткое название языка ("EN" для английского, "RU" для русского и т.д.)
    var shortName: String {
        Bundle.module.moduleLocalizedString(shortNameKey.raw)
    }

    /// Операция сравнения на равенство двух объектов языков
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

/// Тип выбранного языка
enum LangType: String, CustomStringConvertible {
    case source /// исходный язык
    case target /// целевой язык

    static var defaultValue: LangType { .source }

    var description: String {
        "LangType.\(self.rawValue)"
    }
}

/// Данные о языках в приложении.
struct LangData {

    /// Массив всех поддерживаемых языков
    let allLangs: [Lang]

    /// Ключ для персистентного хранения текущего "исходного языка" (source language)
    let sourceLangKey: String

    /// Ключ для персистентного хранения текущего "целевого языка" (target language)
    let targetLangKey: String

    /// Дефолтный исходный язык
    let defaultSourceLang: Lang

    /// Дефолтный целевой язык
    let defaultTargetLang: Lang
}

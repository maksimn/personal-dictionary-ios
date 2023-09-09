//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

import CoreModule

/// Структура с данными об отдельном языке.
struct Lang: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Lang, Int>

    /// Идентификатор языка
    let id: Id

    /// Название языка
    let name: String

    /// Короткое название языка ("EN" для английского, "RU" для русского и т.д.)
    let shortName: String

    /// Операция сравнения на равенство двух объектов языков
    static func == (lhs: Lang, rhs: Lang) -> Bool {
        lhs.id == rhs.id
    }

    var description: String {
        "Lang(id: \(id.raw), name: \(name))"
    }
}

/// Тип выбранного языка
enum LangType {
    case source /// исходный язык
    case target /// целевой язык
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

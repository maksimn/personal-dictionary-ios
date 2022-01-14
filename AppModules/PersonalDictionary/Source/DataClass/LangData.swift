//
//  LangData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.11.2021.
//

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

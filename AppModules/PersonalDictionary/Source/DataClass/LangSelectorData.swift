//
//  LangSelectorData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Данные о выбранном языке
struct LangSelectorData {

    /// Выбранный язык
    let selectedLang: Lang

    /// Тип выбранного языка
    let selectedLangType: SelectedLangType
}

/// Тип выбранного языка
enum SelectedLangType {
    case source /// исходный язык
    case target /// целевой язык
}

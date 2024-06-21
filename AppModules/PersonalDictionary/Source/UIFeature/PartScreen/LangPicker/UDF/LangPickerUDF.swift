//
//  LangPickerUDF.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UDF

enum LangPickerAction: Action {
    case show(LangType)
    case hide
    case langSelected(Lang)
}

/// Данные о выбранном языке
struct LangPickerState: Equatable {

    /// Выбранный язык
    var lang: Lang

    /// Тип выбранного языка
    var langType: LangType

    /// Скрыто ли представление для выбора языка
    var isHidden: Bool

    init(lang: Lang = Lang.empty, langType: LangType = LangType.defaultValue, isHidden: Bool = true) {
        self.lang = lang
        self.langType = langType
        self.isHidden = isHidden
    }
}

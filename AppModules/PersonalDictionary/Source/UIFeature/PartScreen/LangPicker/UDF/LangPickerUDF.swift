//
//  LangPickerUDF.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import UDF

enum LangPickerAction: Action {
    case show(LangType)
    case hide
    case langSelected(Lang)
}

typealias LangPickerState = Nullable<OptionalLangPickerState>

/// Данные о выбранном языке
struct OptionalLangPickerState: Equatable {

    /// Выбранный язык
    var lang: Lang

    /// Тип выбранного языка
    var langType: LangType

    init(lang: Lang = Lang.empty, langType: LangType = LangType.defaultValue) {
        self.lang = lang
        self.langType = langType
    }
}

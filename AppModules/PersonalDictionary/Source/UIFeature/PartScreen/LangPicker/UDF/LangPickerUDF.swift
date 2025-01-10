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

typealias LangPickerState = WrappedOptional<LangPickerData>

/// Данные о выбранном языке
struct LangPickerData: Equatable {

    /// Выбранный язык
    var lang: Lang

    /// Тип выбранного языка
    var langType: LangType

    init(lang: Lang = Lang.empty, langType: LangType = LangType.defaultValue) {
        self.lang = lang
        self.langType = langType
    }
}

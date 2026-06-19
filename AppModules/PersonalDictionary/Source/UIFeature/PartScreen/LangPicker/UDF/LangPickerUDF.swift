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

/// Data about the selected language
struct LangPickerData: Equatable {

    /// Selected language
    var lang: Lang

    /// Type of the selected language
    var langType: LangType

    init(lang: Lang = Lang.empty, langType: LangType = LangType.defaultValue) {
        self.lang = lang
        self.langType = langType
    }
}

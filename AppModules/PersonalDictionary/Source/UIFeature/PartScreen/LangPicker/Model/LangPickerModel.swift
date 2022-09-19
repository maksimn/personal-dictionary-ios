//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Данные о выбранном языке
struct LangPickerState {

    /// Выбранный язык
    let lang: Lang

    /// Тип выбранного языка
    let langType: LangType
}

/// Модель выбора языка.
protocol LangPickerModel: AnyObject {

    /// Данные о выбранном языке.
    var state: LangPickerState? { get set }

    /// Делегат события выбора языка.
    var listener: LangPickerListener? { get set }

    func update(selectedLang: Lang)
}

protocol LangPickerListener: AnyObject {

    func onLangPickerStateChanged(_ state: LangPickerState)
}

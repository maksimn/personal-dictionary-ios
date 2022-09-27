//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Данные о выбранном языке
struct LangPickerState {

    /// Выбранный язык
    var lang: Lang

    /// Тип выбранного языка
    var langType: LangType

    /// Скрыто ли представление для выбора языка
    var isHidden: Bool
}

/// Модель выбора языка.
protocol LangPickerModel: AnyObject {

    var listener: LangPickerListener? { get set }

    func set(state: LangPickerState)
}

protocol LangPickerListener: AnyObject {

    func onLangPickerStateChanged(_ state: LangPickerState)
}

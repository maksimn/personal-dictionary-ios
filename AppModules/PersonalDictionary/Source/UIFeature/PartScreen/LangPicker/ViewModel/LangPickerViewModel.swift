//
//  LangPickerViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Данные о выбранном языке
struct LangPickerState: Equatable {

    /// Выбранный язык
    var lang: Lang

    /// Тип выбранного языка
    var langType: LangType

    /// Скрыто ли представление для выбора языка
    var isHidden: Bool
}

protocol LangPickerListener: AnyObject {

    func onLangPickerStateChanged(_ state: LangPickerState)
}

/// Модель представления Выбора языка.
protocol LangPickerViewModel: AnyObject {

    /// Данные модели представления.
    var state: BindableLangPickerState { get }

    var listener: LangPickerListener? { get set }

    func onSelect(_ lang: Lang)
}

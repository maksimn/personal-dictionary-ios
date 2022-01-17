//
//  LangPickerViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Модель представления Выбора языка.
protocol LangPickerViewModel: AnyObject {

    /// Данные модели представления.
    var langSelectorData: LangSelectorData? { get set }

    /// Отправить сведения о выбранном языке.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func sendSelectedLang(_ lang: Lang)
}

//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Модель выбора языка.
protocol LangPickerModel: AnyObject {

    /// Данные о выбранном языке ("стейт").
    var data: LangSelectorData? { get set }

    /// Модель представления Выбора языка.
    var viewModel: LangPickerViewModel? { get set }

    /// Делегат события выбора языка.
    var listener: LangPickerListener? { get set }

    /// Отправить сведения о выбранном языке.
    /// - Parameters:
    ///  - lang: выбранный язык.
    func sendSelectedLang(_ lang: Lang)
}

/// Делегат события выбора языка.
protocol LangPickerListener: AnyObject {

    /// Обработчик события выбора языка.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func onLangSelected(_ data: LangSelectorData)
}

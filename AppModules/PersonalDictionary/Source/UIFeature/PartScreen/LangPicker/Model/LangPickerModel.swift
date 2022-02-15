//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

/// Модель выбора языка.
protocol LangPickerModel: AnyObject {

    /// Начальные данные о выбранном языке.
    var initData: LangSelectorData? { get set }

    /// Модель представления Выбора языка.
    var viewModel: LangPickerViewModel? { get set }

    /// Делегат события выбора языка.
    var listener: LangPickerListener? { get set }
}

/// Делегат события выбора языка.
protocol LangPickerListener: AnyObject {

    /// Обработчик события выбора языка.
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func onLangSelected(_ data: LangSelectorData)
}

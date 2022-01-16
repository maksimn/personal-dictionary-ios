//
//  LangPickerView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerView: AnyObject {

    /// Модель представления Выбора языка.
    var viewModel: LangPickerViewModel? { get set }

    /// Задать данные для отображения в представлении.
    /// - Parameters:
    ///  - langSelectorData: данные для выбора языка.
    func set(langSelectorData: LangSelectorData)
}

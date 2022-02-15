//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule

/// Стейт модели "Добавления нового слова" в личный словарь.
struct NewWordModelState {
    var text: String
    var sourceLang: Lang
    var targetLang: Lang
    var selectedLangType: SelectedLangType
    var isLangPickerHidden: Bool
}

/// Модель "Добавления нового слова" в личный словарь.
protocol NewWordModel {

    /// View model "Добавления нового слова" в личный словарь.
    var viewModel: NewWordViewModel? { get set }

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String)

    /// Обновить данные об исходном / целевом языке для слова в модели
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func update(data: LangSelectorData)

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - selectedLangType: тип выбранного языка (исходный / целевой).
    func showLangPicker(selectedLangType: SelectedLangType)
}

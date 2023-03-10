//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Данные модели "Добавления нового слова" в личный словарь.
struct NewWordState: Equatable {
    var text: String
    var sourceLang: Lang
    var targetLang: Lang
    var langPickerState: LangPickerState
}

/// Модель представления для экрана добавления нового слова в личный словарь.
protocol NewWordViewModel: AnyObject {

    /// Данные модели представления
    var state: BindableNewWordState { get }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func update(text: String)

    /// Обновить данные об исходном / целевом языке для слова в модели
    func updateStateWith(langPickerState: LangPickerState)

    /// Показать представление для выбора языка.
    /// - Parameters:
    ///  - langType: тип выбранного языка (исходный / целевой).
    func presentLangPicker(langType: LangType)

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()
}

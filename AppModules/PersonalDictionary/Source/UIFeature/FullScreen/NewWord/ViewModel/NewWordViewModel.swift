//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Модель представления для экрана добавления нового слова в личный словарь.
protocol NewWordViewModel: AnyObject {

    /// Данные модели представления
    var state: NewWordModelState? { get set }

    /// Обновить написание слова в модели
    /// - Parameters:
    ///  - text: написание слова
    func updateModel(text: String)

    /// Обновить данные об исходном / целевом языке для слова в модели
    /// - Parameters:
    ///  - data: данные о выбранном языке.
    func updateModel(data: LangSelectorData)

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()
}

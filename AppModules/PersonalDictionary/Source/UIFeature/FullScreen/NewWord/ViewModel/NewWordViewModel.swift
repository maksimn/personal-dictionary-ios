//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxCocoa

/// Модель представления для экрана добавления нового слова в личный словарь.
protocol NewWordViewModel: AnyObject {

    /// Данные модели представления
    var state: BehaviorRelay<NewWordModelState?> { get }

    /// Обновить модель представления.
    /// - Parameters:
    ///  - state: данные модели представления.
    func update(_ state: NewWordModelState)

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
    func showLangPickerView(selectedLangType: SelectedLangType)

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()
}

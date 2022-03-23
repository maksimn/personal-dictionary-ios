//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxCocoa

/// Данные модели "Добавления нового слова" в личный словарь.
struct NewWordState {
    var text: String
    var sourceLang: Lang
    var targetLang: Lang
    var selectedLangType: SelectedLangType
    var isLangPickerHidden: Bool
}

/// Модель представления для экрана добавления нового слова в личный словарь.
protocol NewWordViewModel: AnyObject {

    /// Данные модели представления
    var state: BehaviorRelay<NewWordState> { get }

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
    func presentLangPickerView(selectedLangType: SelectedLangType)

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()
}

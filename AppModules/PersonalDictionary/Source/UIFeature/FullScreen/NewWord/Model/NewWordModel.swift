//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Данные модели "Добавления нового слова" в личный словарь.
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

    /// Сохранить исходный язык.
    func save(sourceLang: Lang)

    /// Сохранить целевой язык.
    func save(targetLang: Lang)
}

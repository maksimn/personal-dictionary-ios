//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Модель "Добавления нового слова" в личный словарь.
protocol NewWordModel {

    /// Отправить событие добавления нового слова в словарь
    func sendNewWord()

    /// Сохранить исходный язык.
    func save(sourceLang: Lang)

    /// Сохранить целевой язык.
    func save(targetLang: Lang)
}

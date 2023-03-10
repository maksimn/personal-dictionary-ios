//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Модель "Добавления нового слова" в личный словарь.
protocol NewWordModel {

    func selectLangEffect(_ langPickerState: LangPickerState, state: NewWordState) -> NewWordState

    func presentLangPicker(langType: LangType, state: NewWordState) -> NewWordState

    func sendNewWord(_ state: NewWordState)
}

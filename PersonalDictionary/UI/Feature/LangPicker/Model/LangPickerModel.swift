//
//  LangPickerModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

protocol LangPickerModel {

    var viewModel: LangPickerViewModel? { get set }

    func sendSelectedLang(_ lang: Lang)
}

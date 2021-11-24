//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordModel: InitiallyBindable {

    var viewModel: NewWordViewModel? { get set }

    func sendNewWord()

    func update(_ langType: SelectedLangType, _ lang: Lang)
}

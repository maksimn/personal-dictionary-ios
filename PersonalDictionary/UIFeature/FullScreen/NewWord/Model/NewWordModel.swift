//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

struct NewWordModelState {
    var text: String
    var sourceLang: Lang
    var targetLang: Lang
}

protocol NewWordModel: InitiallyBindable {

    var viewModel: NewWordViewModel? { get set }

    func sendNewWord()

    func update(text: String)

    func update(data: LangSelectorData)
}

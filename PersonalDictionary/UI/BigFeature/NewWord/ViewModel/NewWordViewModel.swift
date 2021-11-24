//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordViewModel: AnyObject {

    var text: String { get set }

    var sourceLang: Lang { get set }

    var targetLang: Lang { get set }

    func updateModel(_ langType: SelectedLangType, _ lang: Lang)

    func sendNewWordEvent()
}

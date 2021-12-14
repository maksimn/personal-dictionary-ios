//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordViewModel: AnyObject {

    var state: NewWordModelState? { get set }

    func updateModel(text: String)

    func updateModel(data: LangSelectorData)

    func sendNewWord()
}

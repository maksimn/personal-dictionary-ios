//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordModel {

    var viewModel: NewWordViewModel? { get }

    func bindData()

    func save(sourceLang: Lang)

    func save(targetLang: Lang)
}
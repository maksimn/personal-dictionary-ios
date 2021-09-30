//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordViewModel {

    func bindDataFromModel()

    var allLangs: [String] { get set }

    var sourceLang: String { get set }

    var targetLang: String { get set }
}

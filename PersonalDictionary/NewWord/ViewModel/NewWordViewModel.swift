//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordViewModel {

    var allLangs: [Lang] { get set }

    var sourceLang: Lang { get set }

    var targetLang: Lang { get set }

    func bindDataFromModel()

    func saveSourceAndTargetLangs()
}

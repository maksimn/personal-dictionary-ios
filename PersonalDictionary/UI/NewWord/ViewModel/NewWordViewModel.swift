//
//  NewWordViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordViewModel: AnyObject {

    var allLangs: [Lang] { get set }

    var sourceLang: Lang { get set }

    var targetLang: Lang { get set }

    func fetchDataFromModel()

    func sendNewWordEvent(_ newWordText: String)
}

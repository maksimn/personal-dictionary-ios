//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordView: AnyObject {

    var viewModel: NewWordViewModel? { get }

    func set(allLangs: [String])

    func set(sourceLang: String)

    func set(targetLang: String)
}

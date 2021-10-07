//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordView: AnyObject {

    var viewModel: NewWordViewModel? { get set }

    func set(allLangs: [Lang])

    func set(sourceLang: Lang)

    func set(targetLang: Lang)
}

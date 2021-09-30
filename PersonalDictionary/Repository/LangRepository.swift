//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol LangRepository {

    var allLangs: [String] { get }

    var sourceLang: String { get }

    var targetLang: String { get }
}

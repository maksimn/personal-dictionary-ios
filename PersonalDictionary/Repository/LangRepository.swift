//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol LangRepository {

    var allLangs: [Lang] { get }

    var sourceLang: Lang { get }

    var targetLang: Lang { get }
}

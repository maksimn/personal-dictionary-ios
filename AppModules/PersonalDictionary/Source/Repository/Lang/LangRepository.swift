//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

/// Storage for language data in the application.
protocol LangRepository {

    /// List of all languages
    var allLangs: [Lang] { get }

    /// Save and retrieve the source language
    var sourceLang: Lang { get set }

    /// Save and retrieve the target language
    var targetLang: Lang { get set }
}

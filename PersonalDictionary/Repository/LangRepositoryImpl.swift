//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

final class LangRepositoryImpl: LangRepository {

    let allLangs = ["Английский", "Русский", "Французский", "Итальянский"]

    var sourceLang: String {
        sourceLangDefault
    }

    var targetLang: String {
        targetLangDefault
    }

    private var sourceLangDefault: String {
        "Английский"
    }

    private var targetLangDefault: String {
        "Русский"
    }
}

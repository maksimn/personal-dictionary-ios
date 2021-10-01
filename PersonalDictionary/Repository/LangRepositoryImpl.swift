//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

final class LangRepositoryImpl: LangRepository {

    let allLangs = [Lang(name: "Английский"),
                    Lang(name: "Русский"),
                    Lang(name: "Французский"),
                    Lang(name: "Итальянский")]

    var sourceLang: Lang {
        sourceLangDefault
    }

    var targetLang: Lang {
        targetLangDefault
    }

    private var sourceLangDefault: Lang {
        allLangs[0]
    }

    private var targetLangDefault: Lang {
        allLangs[1]
    }
}

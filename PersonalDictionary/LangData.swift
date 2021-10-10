//
//  LangData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import Foundation

struct LangData {
    let allLangs: [Lang]
    let sourceLangKey: String
    let targetLangKey: String
    let defaultSourceLang: Lang
    let defaultTargetLang: Lang
}

private let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
private let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
private let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
private let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

let langData = LangData(allLangs: [lang1, lang2, lang3, lang4],
                        sourceLangKey: "io.github.maksimn.pd.sourceLang",
                        targetLangKey: "io.github.maksimn.pd.targetLang",
                        defaultSourceLang: lang1,
                        defaultTargetLang: lang2)

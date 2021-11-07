//
//  PDGlobalSettings+values.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.11.2021.
//

import UIKit

private let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
private let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
private let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
private let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

private let langData = LangData(allLangs: [lang1, lang2, lang3, lang4],
                                sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                targetLangKey: "io.github.maksimn.pd.targetLang",
                                defaultSourceLang: lang1,
                                defaultTargetLang: lang2)

let pdGlobalSettings = PDGlobalSettings(

    isLoggingEnabled: true,

    appBackgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),

    langData: langData,

    ponsApiSecret: ""
)

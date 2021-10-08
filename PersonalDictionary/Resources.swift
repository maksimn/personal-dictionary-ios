//
//  Values.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

private let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
private let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
private let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
private let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

let langResourceData = LangResourceData(allLangs: [lang1, lang2, lang3, lang4],
                                        sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                        targetLangKey: "io.github.maksimn.pd.targetLang",
                                        defaultSourceLang: lang1,
                                        defaultTargetLang: lang2)

let newWordViewResource = NewWordViewResource(selectButtonTitle: NSLocalizedString("Select", comment: ""),
                                              arrowText: NSLocalizedString("⇋", comment: ""),
                                              okText: NSLocalizedString("OK", comment: ""),
                                              textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: ""),
                                              backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0))

struct WebApiData {
    let yandexTranslatorApiKey: String
}

let webApiData = WebApiData(
    yandexTranslatorApiKey: "trnsl.1.1.20190308T225103Z.03f7eccfa6946358.fcc85b6387d6223f20a548dbcc0789a46272150b"
)

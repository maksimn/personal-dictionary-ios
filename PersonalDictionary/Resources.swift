//
//  Values.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

private let lang1 = Lang(id: 1, name: NSLocalizedString("English", comment: ""))
private let lang2 = Lang(id: 2, name: NSLocalizedString("Russian", comment: ""))
private let lang3 = Lang(id: 3, name: NSLocalizedString("French", comment: ""))
private let lang4 = Lang(id: 4, name: NSLocalizedString("Italian", comment: ""))

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

//
//  Values.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

let langResourceData = LangResourceData(allLangs: [Lang(name: NSLocalizedString("English", comment: "")),
                                                   Lang(name: NSLocalizedString("Russian", comment: "")),
                                                   Lang(name: NSLocalizedString("French", comment: "")),
                                                   Lang(name: NSLocalizedString("Italian", comment: ""))],
                                        sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                        targetLangKey: "io.github.maksimn.pd.targetLang",
                                        defaultSourceLang: Lang(name: NSLocalizedString("English", comment: "")),
                                        defaultTargetLang: Lang(name: NSLocalizedString("Russian", comment: "")))

let newWordViewResource = NewWordViewResource(selectButtonTitle: NSLocalizedString("Select", comment: ""),
                                              arrowText: NSLocalizedString("⇋", comment: ""),
                                              okText: NSLocalizedString("OK", comment: ""),
                                              textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: ""),
                                              backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0))

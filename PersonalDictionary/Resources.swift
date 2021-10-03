//
//  Values.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

let langResourceData = LangResourceData(allLangs: [Lang(name: "Английский"),
                                                   Lang(name: "Русский"),
                                                   Lang(name: "Французский"),
                                                   Lang(name: "Итальянский")],
                                        sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                        targetLangKey: "io.github.maksimn.pd.targetLang",
                                        defaultSourceLang: Lang(name: "Английский"),
                                        defaultTargetLang: Lang(name: "Русский"))

let newWordViewResource = NewWordViewResource(selectButtonTitle: "Выбрать",
                                              arrowText: "⇋",
                                              okText: "OK",
                                              textFieldPlaceholder: "Впишите новое слово",
                                              backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0))

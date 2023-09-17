//
//  AppConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

struct AppConfigFactory {

    func create() -> AppConfig {
        AppConfig(
            langData: createLangData(),
            ponsApiSecret: "",
            everydayPNTime: AppConfig.EverydayPNTime(hours: 19, minutes: 30)
        )
    }

    private func createLangData() -> LangData {
        let lang1 = Lang(id: Lang.Id(raw: 1), nameKey: .init(raw: "LS_ENGLISH"), shortNameKey: .init(raw: "LS_EN"))
        let lang2 = Lang(id: Lang.Id(raw: 2), nameKey: .init(raw: "LS_RUSSIAN"), shortNameKey: .init(raw: "LS_RU"))
        let lang4 = Lang(id: Lang.Id(raw: 4), nameKey: .init(raw: "LS_ITALIAN"), shortNameKey: .init(raw: "LS_IT"))
        let lang5 = Lang(id: Lang.Id(raw: 5), nameKey: .init(raw: "LS_GERMAN"), shortNameKey: .init(raw: "LS_DE"))
        let langData = LangData(
            allLangs: [lang1, lang2, lang4, lang5],
            sourceLangKey: "io.github.maksimn.pd.sourceLang",
            targetLangKey: "io.github.maksimn.pd.targetLang",
            defaultSourceLang: lang1,
            defaultTargetLang: lang2
        )

        return langData
    }
}

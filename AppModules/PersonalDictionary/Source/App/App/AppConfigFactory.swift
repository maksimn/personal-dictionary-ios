//
//  AppConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

struct AppConfigFactory {

    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func create() -> AppConfig {
        AppConfig(
            langData: createLangData(),
            ponsApiSecret: "",
            everydayPNTime: AppConfig.EverydayPNTime(hh: 19, mm: 30)
        )
    }

    private func createLangData() -> LangData {
        let lang1 = Lang(id: Lang.Id(raw: 1), name: bundle.moduleLocalizedString("LS_ENGLISH"), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: bundle.moduleLocalizedString("LS_RUSSIAN"), shortName: "RU")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: bundle.moduleLocalizedString("LS_ITALIAN"), shortName: "IT")
        let lang5 = Lang(id: Lang.Id(raw: 5), name: bundle.moduleLocalizedString("LS_GERMAN"), shortName: "DE")
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

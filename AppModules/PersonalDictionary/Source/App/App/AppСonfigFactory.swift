//
//  AppConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

protocol AppConfigFactory {

    func create() -> AppConfig
}

final class DevAppConfigFactory: AppConfigFactory {

    func create() -> AppConfig {
        let bundle = Bundle(for: type(of: self))
        let lang1 = Lang(id: Lang.Id(raw: 1), name: bundle.moduleLocalizedString("English"), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: bundle.moduleLocalizedString("Russian"), shortName: "RU")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: bundle.moduleLocalizedString("Italian"), shortName: "IT")
        let lang5 = Lang(id: Lang.Id(raw: 5), name: bundle.moduleLocalizedString("German"), shortName: "DE")
        let langData = LangData(
            allLangs: [lang1, lang2, lang4, lang5],
            sourceLangKey: "io.github.maksimn.pd.sourceLang",
            targetLangKey: "io.github.maksimn.pd.targetLang",
            defaultSourceLang: lang1,
            defaultTargetLang: lang2
        )

        return AppConfig(
            bundle: bundle,
            langData: langData,
            ponsApiSecret: "",
            isLoggingEnabled: true,
            everydayPNTime: AppConfig.EverydayPNTime(hh: 19, mm: 30)
        )
    }
}

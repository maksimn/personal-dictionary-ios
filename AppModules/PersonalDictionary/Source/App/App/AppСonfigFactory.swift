//
//  AppConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

struct AppConfigFactory {

    private let variant: AppConfig.Variant
    private let bundle: Bundle

    init(variant: AppConfig.Variant,
         bundle: Bundle) {
        self.variant = variant
        self.bundle = bundle
    }

    func create() -> AppConfig {
        switch variant {
        case .development:
            return createAppConfig(isLoggingEnabled: true)
        case .production:
            return createAppConfig(isLoggingEnabled: false)
        }
    }

    private func createAppConfig(isLoggingEnabled: Bool) -> AppConfig {
        AppConfig(
            langData: createLangData(),
            ponsApiSecret: "",
            isLoggingEnabled: isLoggingEnabled,
            everydayPNTime: AppConfig.EverydayPNTime(hh: 19, mm: 30)
        )
    }

    private func createLangData() -> LangData {
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

        return langData
    }
}

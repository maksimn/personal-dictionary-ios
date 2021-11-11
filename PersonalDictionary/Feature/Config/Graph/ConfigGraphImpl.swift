//
//  ConfigGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

final class ConfigGraphImpl: ConfigGraph {

    private(set) var appConfigs: AppConfigs

    init() {
        let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
        let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

        let langData = LangData(allLangs: [lang1, lang2, lang3, lang4],
                                sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                targetLangKey: "io.github.maksimn.pd.targetLang",
                                defaultSourceLang: lang1,
                                defaultTargetLang: lang2)

        appConfigs = AppConfigs(

            isLoggingEnabled: true,

            langData: langData,

            ponsApiSecret: "",

            appViewConfigs: AppViewConfigs(
                appBackgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
            )
        )
    }

    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: appConfigs)
    }
}

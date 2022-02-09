//
//  ConfigDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

/// Зависимости для Фичи "Конфигурация приложения".
final class ConfigDependencies {

    /// Конфигурация приложения "Личный словарь иностранных слов".
    private(set) lazy var appConfigs: AppConfigs = {
        let bundle = Bundle(for: type(of: self))
        let lang1 = Lang(id: Lang.Id(raw: 1), name: bundle.moduleLocalizedString("English"), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: bundle.moduleLocalizedString("Russian"), shortName: "RU")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: bundle.moduleLocalizedString("Italian"), shortName: "IT")
        let lang5 = Lang(id: Lang.Id(raw: 5), name: bundle.moduleLocalizedString("German"), shortName: "DE")

        let langData = LangData(allLangs: [lang1, lang2, lang4, lang5],
                                sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                targetLangKey: "io.github.maksimn.pd.targetLang",
                                defaultSourceLang: lang1,
                                defaultTargetLang: lang2)

        return AppConfigs(

            appParams: appParams,

            langData: langData,

            ponsApiSecret: "",

            isLoggingEnabled: true
        )
    }()

    private let appParams: PersonalDictionaryAppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - appParams: внешние параметры приложения "Личный словарь".
    init(appParams: PersonalDictionaryAppParams) {
        self.appParams = appParams
    }
}

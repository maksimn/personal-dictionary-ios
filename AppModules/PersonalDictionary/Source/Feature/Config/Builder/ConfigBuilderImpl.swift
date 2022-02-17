//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Реализация билдера конфигурации приложения "Личный словарь".
final class ConfigBuilderImpl: ConfigBuilder {

    private let appParams: PersonalDictionaryAppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - appParams: внешние параметры приложения "Личный словарь".
    init(appParams: PersonalDictionaryAppParams) {
        self.appParams = appParams
    }

    /// Создать конфигурацию приложения.
    func build() -> AppConfigs {
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
    }

    /// Создать билдер Фичи "Главный/основной список слов".
    /// - Returns: билдер указанной фичи.
    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(externals: self)
    }
}

/// Для передачи внешних зависимостей в чайлд-фичу "Главный список слов".
extension ConfigBuilderImpl: MainWordListExternals {

    var appConfig: AppConfigs {
        build()
    }
}

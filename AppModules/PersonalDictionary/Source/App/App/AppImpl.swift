//
//  AppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Общий протокол из базовых зависимостей в приложении.
protocol BaseDependency {

    /// Корневой navigation controller приложения.
    var navigationController: UINavigationController { get }

    /// Конфигурация приложения.
    var appConfig: Config { get }
}

/// Реализация приложения "Личный словарь иностранных слов".
final class AppImpl: App, BaseDependency {

    /// Получение корневого контроллера приложения
    let navigationController = UINavigationController()

    private(set) lazy var appConfig: Config = buildConfig()

    private let appParams: AppParams

    /// Инициализатор:
    /// - Parameters:
    ///  - appParams: внешние параметры для приложения.
    init(appParams: AppParams) {
        self.appParams = appParams

        let mainWordListBuilder = MainWordListBuilderImpl(dependency: self)
        let mainWordListViewController = mainWordListBuilder.build()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([mainWordListViewController], animated: false)
    }

    /// Создать конфигурацию приложения.
    private func buildConfig() -> Config {
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

        return Config(
            appParams: appParams,
            langData: langData,
            ponsApiSecret: "",
            isLoggingEnabled: true
        )
    }
}

extension AppImpl: MainWordListDependency { }

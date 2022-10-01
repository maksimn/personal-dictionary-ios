//
//  AppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

/// Общий протокол из базовых зависимостей в приложении.
protocol BaseDependency {

    /// Корневой navigation controller приложения.
    var navigationController: UINavigationController? { get }

    /// Конфигурация приложения.
    var appConfig: AppConfig { get }
}

/// Зависимости вложенных фич "Главный список слов", "Пуш-уведомления".
private struct BaseDependencyImpl: MainWordListDependency, PushNotificationDependency {

    let navigationController: UINavigationController?

    let appConfig: AppConfig
}

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class AppBuilderImpl: AppBuilder {

    /// Инициализатор.
    public init() { }

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        let baseDependency = BaseDependencyImpl(
            navigationController: UINavigationController(),
            appConfig: buildConfig()
        )

        return AppImpl(
            navigationController: baseDependency.navigationController,
            mainWordListBuilder: MainWordListBuilderImpl(dependency: baseDependency),
            pushNotificationBuilder: PushNotificationBuilderImpl(dependency: baseDependency)
        )
    }

    /// Создать конфигурацию приложения.
    private func buildConfig() -> AppConfig {
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

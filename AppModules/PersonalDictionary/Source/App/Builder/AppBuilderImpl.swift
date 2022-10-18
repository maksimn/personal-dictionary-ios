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
        let appConfigFactory = DevAppConfigFactory()
        let baseDependency = BaseDependencyImpl(
            navigationController: UINavigationController(),
            appConfig: appConfigFactory.create()
        )

        return AppImpl(
            navigationController: baseDependency.navigationController,
            mainWordListBuilder: MainWordListBuilderImpl(dependency: baseDependency),
            pushNotificationBuilder: PushNotificationBuilderImpl(dependency: baseDependency)
        )
    }
}

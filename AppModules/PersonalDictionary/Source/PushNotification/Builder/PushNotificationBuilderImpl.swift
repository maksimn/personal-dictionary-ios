//
//  PushNotificationBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import CoreModule
import UIKit
import UserNotifications

/// Зависимости фичи "Пуш-уведомления в приложении".
protocol PushNotificationDependency: BaseDependency { }

/// Реализация билдера фичи "Пуш-уведомления в приложении".
final class PushNotificationBuilderImpl: PushNotificationBuilder {

    private let appConfig: AppConfig
    private weak var navigationController: UINavigationController?

    /// Инициализатор.
    /// - Parameters:
    ///  - dependency: зависимости фичи.
    init(dependency: PushNotificationDependency) {
        appConfig = dependency.appConfig
        navigationController = dependency.navigationController
    }

    /// Метод билдера.
    /// - Returns:
    ///  -  объект службы для работы с пуш-уведомлениями.
    func build() -> PushNotificationService {
        let bundle = appConfig.bundle
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard, data: appConfig.langData)
        let everydayPNTime = appConfig.everydayPNTime

        return PushNotificationServiceImpl(
            userNotificationCenter: UNUserNotificationCenter.current(),
            application: UIApplication.shared,
            pnTimeCalculator: EverydayPNTimeCalculator(
                hh: everydayPNTime.hh,
                mm: everydayPNTime.mm,
                calendar: Calendar.current
            ),
            pnContent: PNContentImpl(
                title: bundle.moduleLocalizedString("Advice"),
                body: bundle.moduleLocalizedString("It's time to add a new word to the dictionary.")
            ),
            navToNewWordRouter: NavToNewWordRouterImpl(
                navigationController: navigationController,
                newWordBuilder: NewWordBuilderImpl(bundle: bundle, langRepository: langRepository)
            ),
            logger: LoggerImpl(isLoggingEnabled: appConfig.isLoggingEnabled)
        )
    }
}

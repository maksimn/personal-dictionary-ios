//
//  PushNotificationBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import CoreModule
import UIKit
import UserNotifications

/// Реализация билдера фичи "Пуш-уведомления в приложении".
final class PushNotificationBuilderImpl: PushNotificationBuilder {

    private weak var dependency: AppDependency?

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Метод билдера.
    /// - Returns:
    ///  -  объект службы для работы с пуш-уведомлениями.
    func build() -> PushNotificationService {
        guard let appConfig = dependency?.appConfig,
              let bundle = dependency?.bundle else { return EmptyService() }
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
            navToNewWordRouter: NavToNewWordRouter(
                navigationController: dependency?.navigationController,
                newWordBuilder: NewWordBuilderImpl(bundle: bundle, langRepository: langRepository)
            ),
            logger: LoggerImpl(category: "PersonalDictionary.PushNotification")
        )
    }
}

private struct EmptyService: PushNotificationService {

    func schedule() { }
}

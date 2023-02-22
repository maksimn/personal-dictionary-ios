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

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Метод билдера.
    /// - Returns:
    ///  -  объект службы для работы с пуш-уведомлениями.
    func build() -> PushNotificationService {
        let appConfig = dependency.appConfig
        let bundle = dependency.bundle

        return PushNotificationServiceImpl(
            userNotificationCenter: UNUserNotificationCenter.current(),
            application: UIApplication.shared,
            pnTimeCalculator: pnTimeCalculator(appConfig),
            pushNotificationData: pushNotificationData(bundle),
            navToNewWordRouter: router(bundle, appConfig),
            logger: LoggerImpl(category: "PersonalDictionary.PushNotification")
        )
    }

    private func pnTimeCalculator(_ appConfig: AppConfig) -> PNTimeCalculator {
        let everydayPNTime = appConfig.everydayPNTime

        return EverydayPNTimeCalculator(
            hh: everydayPNTime.hh,
            mm: everydayPNTime.mm,
            calendar: Calendar.current
        )
    }

    private func pushNotificationData(_ bundle: Bundle) -> PushNotificationData {
        let pnTitle = bundle.moduleLocalizedString("MLS_ADVICE")
        let pnBody = bundle.moduleLocalizedString("MLS_ADD_NEW_WORD_SUGGESTION")

        return PushNotificationData(title: pnTitle, body: pnBody)
    }

    private func router(_ bundle: Bundle, _ appConfig: AppConfig) -> NavToNewWordRouter {
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard, data: appConfig.langData)
        let newWordBuilder = NewWordBuilderImpl(bundle: bundle, langRepository: langRepository)

        return NavToNewWordRouter(
            navigationController: dependency.navigationController,
            newWordBuilder: newWordBuilder
        )
    }
}

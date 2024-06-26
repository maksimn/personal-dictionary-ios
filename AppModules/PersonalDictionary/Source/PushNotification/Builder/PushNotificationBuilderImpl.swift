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
    private let featureName = "PersonalDictionary.PushNotification"

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Метод билдера.
    /// - Returns:
    ///  -  объект службы для работы с пуш-уведомлениями.
    func build() -> PushNotificationService {
        PushNotificationServiceImpl(
            userNotificationCenter: UNUserNotificationCenter.current(),
            application: UIApplication.shared,
            pnTimeCalculator: pnTimeCalculator(),
            pushNotificationData: pushNotificationData(),
            navToNewWordRouter: navToNewWordRouter(),
            logger: LoggerImpl(category: featureName)
        )
    }

    private func pnTimeCalculator() -> PNTimeCalculator {
        let everydayPNTime = dependency.appConfig.everydayPNTime

        return EverydayPNTimeCalculator(
            hours: everydayPNTime.hours,
            minutes: everydayPNTime.minutes,
            calendar: Calendar.current
        )
    }

    private func pushNotificationData() -> PushNotificationData {
        let bundle = dependency.bundle
        let pnTitle = bundle.moduleLocalizedString("LS_ADVICE")
        let pnBody = bundle.moduleLocalizedString("LS_ADD_NEW_WORD_SUGGESTION")

        return PushNotificationData(title: pnTitle, body: pnBody)
    }

    private func navToNewWordRouter() -> NavToNewWordRouter {
        let appConfig = dependency.appConfig
        let bundle = dependency.bundle
        let newWordBuilder = NewWordBuilder(bundle: bundle, langData: appConfig.langData)

        return NavToNewWordRouter(
            navigationController: dependency.navigationController,
            newWordBuilder: newWordBuilder
        )
    }
}

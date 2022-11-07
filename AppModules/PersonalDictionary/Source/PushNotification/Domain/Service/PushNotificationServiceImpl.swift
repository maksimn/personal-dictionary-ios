//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import CoreModule
import UIKit
import UserNotifications

/// Реализация службы для работы с пуш-уведомлениями.
final class PushNotificationServiceImpl: NSObject, PushNotificationService, UNUserNotificationCenterDelegate {

    private let userNotificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    private let pnTimeCalculator: PNTimeCalculator
    private let pnContent: PNContent
    private let navToNewWordRouter: CoreRouter
    private let logger: Logger

    init(userNotificationCenter: UNUserNotificationCenter,
         application: UIApplication,
         pnTimeCalculator: PNTimeCalculator,
         pnContent: PNContent,
         navToNewWordRouter: CoreRouter,
         logger: Logger) {
        self.userNotificationCenter = userNotificationCenter
        self.application = application
        self.pnTimeCalculator = pnTimeCalculator
        self.pnContent = pnContent
        self.navToNewWordRouter = navToNewWordRouter
        self.logger = logger
        super.init()
        requestAuthorization()
    }

    /// Поставить показ уведомления в расписание.
    /// Метод должен быть вызван в момент, когда приложение уходит с экрана (становится неактивным).
    public func schedule() {
        let notificationRequest = UNNotificationRequest(
            identifier: "PersonalDictionaryNotificationId",
            content: pnContent.get,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: pnTimeCalculator.calculate(forDate: Date()),
                repeats: false
            )
        )

        userNotificationCenter.add(notificationRequest, withCompletionHandler: { [weak self] error in
            if let error = error {
                self?.logger.log(error: error)
            } else {
                self?.logger.log(message: "PushNotificationService schedule SUCCESS.")
            }
        })
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if application.applicationState == .background {
            completionHandler([.banner, .sound, .badge])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        navToNewWordRouter.navigate()
        completionHandler()
    }

    // MARK: - Private

    private func requestAuthorization() {
        userNotificationCenter.delegate = self
        userNotificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, error in
                if !granted, let error = error {
                    self?.logger.log(error: error)
                } else {
                    self?.logger.log(message: "PushNotificationService requestAuthorization SUCCESS.")
                }
            }
        )
    }
}

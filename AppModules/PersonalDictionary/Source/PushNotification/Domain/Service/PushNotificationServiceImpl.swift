//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import CoreModule
import UIKit
import UserNotifications

struct PushNotificationData {
    let title: String
    let body: String
}

/// Реализация службы для работы с пуш-уведомлениями.
final class PushNotificationServiceImpl: NSObject, PushNotificationService, UNUserNotificationCenterDelegate {

    private let userNotificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    private let pnTimeCalculator: PNTimeCalculator
    private let pushNotificationData: PushNotificationData
    private let navToNewWordRouter: Router
    private let logger: Logger

    private lazy var content = {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = pushNotificationData.title
        notificationContent.body = pushNotificationData.body
        notificationContent.sound = .default

        return notificationContent
    }()

    init(userNotificationCenter: UNUserNotificationCenter,
         application: UIApplication,
         pnTimeCalculator: PNTimeCalculator,
         pushNotificationData: PushNotificationData,
         navToNewWordRouter: Router,
         logger: Logger) {
        self.userNotificationCenter = userNotificationCenter
        self.application = application
        self.pnTimeCalculator = pnTimeCalculator
        self.pushNotificationData = pushNotificationData
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
            content: content,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: pnTimeCalculator.calculate(forDate: Date()),
                repeats: true
            )
        )

        userNotificationCenter.add(notificationRequest, withCompletionHandler: { [weak self] error in
            if let error = error {
                self?.logger.errorWithContext(error)
            } else {
                self?.logger.logWithContext("PushNotificationService schedule SUCCESS.")
            }
        })
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if application.applicationState == .background {
            completionHandler([.banner, .list, .sound])
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
                    self?.logger.errorWithContext(error)
                } else {
                    self?.logger.log(installedFeatureName: "PushNotificationService")
                }
            }
        )
    }
}

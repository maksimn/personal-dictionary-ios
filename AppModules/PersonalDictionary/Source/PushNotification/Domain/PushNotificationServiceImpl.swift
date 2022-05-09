//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import CoreModule
import UserNotifications

final class PushNotificationServiceImpl: NSObject, PushNotificationService, UNUserNotificationCenterDelegate {

    private let userNotificationCenter: UNUserNotificationCenter
    private let datetimeCalculator: DatetimeCalculator
    private let navToNewWordRouter: NavToNewWordRouter
    private let bundle: Bundle
    private let logger: Logger

    init(userNotificationCenter: UNUserNotificationCenter,
         datetimeCalculator: DatetimeCalculator,
         navToNewWordRouter: NavToNewWordRouter,
         bundle: Bundle,
         logger: Logger) {
        self.userNotificationCenter = userNotificationCenter
        self.datetimeCalculator = datetimeCalculator
        self.navToNewWordRouter = navToNewWordRouter
        self.bundle = bundle
        self.logger = logger
        super.init()
        requestAuthorization()
    }

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

    public func schedule() {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = bundle.moduleLocalizedString("Advice")
        notificationContent.body = bundle.moduleLocalizedString("It's time to add a new word to the dictionary.")
        notificationContent.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            Set([.year, .month, .day, .hour, .minute, .second]),
            from: datetimeCalculator.calculate()
        )
        let notificationRequest = UNNotificationRequest(
            identifier: "PersonalDictionaryNotificationId",
            content: notificationContent,
            trigger: UNCalendarNotificationTrigger(
                dateMatching: triggerDate,
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

    func userNotificationCenter(_ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if UIApplication.shared.applicationState == .background {
            completionHandler([.banner, .sound, .badge])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        navToNewWordRouter.navigate()
        completionHandler()
    }
}

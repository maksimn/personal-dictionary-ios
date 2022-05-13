//
//  TextPNContent.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import UserNotifications

/// Контент для пуш-уведомления.
final class PNContentImpl: PNContent {

    private let title: String
    private let body: String

    /// Инициализатор.
    /// - Parameters:
    ///  - title: заголовок уведомления.
    ///  - body: тело уведомления.
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

    /// Получить объект контента для системного пуш-уведомления.
    var get: UNNotificationContent {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default

        return notificationContent
    }
}

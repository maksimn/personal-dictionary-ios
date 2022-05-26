//
//  TextPNContent.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import UserNotifications

/// Контент для пуш-уведомления.
final class PNContentImpl: PNContent {

    private let notificationContent = UNMutableNotificationContent()

    /// Инициализатор.
    /// - Parameters:
    ///  - title: заголовок уведомления.
    ///  - body: тело уведомления.
    init(title: String, body: String) {
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
    }

    /// Получить объект контента для системного пуш-уведомления.
    var get: UNNotificationContent {
        notificationContent
    }
}

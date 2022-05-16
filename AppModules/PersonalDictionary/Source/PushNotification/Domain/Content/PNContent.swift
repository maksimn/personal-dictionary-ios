//
//  PNContent.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import UserNotifications

/// Контент для пуш-уведомления.
protocol PNContent {

    /// Получить объект контента для системного пуш-уведомления.
    var get: UNNotificationContent { get }
}

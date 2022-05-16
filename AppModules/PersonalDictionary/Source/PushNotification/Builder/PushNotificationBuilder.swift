//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

/// Билдер фичи "Пуш-уведомления в приложении".
protocol PushNotificationBuilder {

    /// Метод билдера.
    /// - Returns:
    ///  -  объект службы для работы с пуш-уведомлениями.
    func build() -> PushNotificationService
}

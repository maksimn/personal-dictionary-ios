//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

/// Builder of the "Push Notifications in the Application" feature.
protocol PushNotificationBuilder {

    /// Builder method.
    /// - Returns:
    ///  - service object for working with push notifications.
    func build() -> PushNotificationService
}

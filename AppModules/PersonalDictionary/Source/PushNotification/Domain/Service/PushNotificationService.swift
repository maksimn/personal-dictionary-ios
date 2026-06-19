//
//  PushNotificationBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

/// Service for working with push notifications.
public protocol PushNotificationService {

    /// Schedule a notification for display.
    /// The method should be called when the application goes off screen (becomes inactive).
    func schedule()
}

//
//  App.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Root object of the "Personal Dictionary" application.
public struct App {

    /// Root view controller of the application
    public let rootViewController: UIViewController

    /// Service for working with push notifications.
    public let pushNotificationService: PushNotificationService
}

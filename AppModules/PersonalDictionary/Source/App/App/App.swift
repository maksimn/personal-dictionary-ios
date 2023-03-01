//
//  App.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Корневой объект приложения "Личный словарь иностранных слов".
public struct App {

    /// Корневой контроллер приложения
    public let rootViewController: UIViewController

    /// Служба для работы с пуш-уведомлениями.
    public let pushNotificationService: PushNotificationService
}

//
//  AppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Реализация приложения "Личный словарь иностранных слов".
struct AppImpl: App {

    /// Корневой контроллер приложения
    let rootViewController: UIViewController

    /// Служба для работы с пуш-уведомлениями.
    let pushNotificationService: PushNotificationService
}

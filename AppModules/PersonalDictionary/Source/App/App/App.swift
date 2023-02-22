//
//  App.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Приложение "Личный словарь иностранных слов".
public protocol App {

    /// Получение корневого контроллера приложения
    var rootViewController: UIViewController { get }

    /// Служба для работы с пуш-уведомлениями.
    var pushNotificationService: PushNotificationService { get }
}

//
//  App.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Корневой объект приложения "Личный словарь иностранных слов".
public protocol App {

    /// Корневой контроллер приложения
    var rootViewController: UIViewController { get }

    /// Служба для работы с пуш-уведомлениями.
    var pushNotificationService: PushNotificationService { get }
}

struct AppImpl: App {

    let rootViewController: UIViewController
    let pushNotificationService: PushNotificationService

    private let effectHolder: EffectHolder

    init(
        rootViewController: UIViewController,
        pushNotificationService: PushNotificationService,
        effectHolder: EffectHolder
    ) {
        self.rootViewController = rootViewController
        self.pushNotificationService = pushNotificationService
        self.effectHolder = effectHolder
    }
}

//
//  AppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Реализация приложения "Личный словарь иностранных слов".
final class AppImpl: App {

    /// Получение корневого контроллера приложения
    private(set) var rootViewController: UIViewController?

    /// Служба для работы с пуш-уведомлениями.
    private(set) var pushNotificationService: PushNotificationService

    private let dependency: AppDependency

    /// Инициализатор:
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    ///  - pushNotificationBuilder: билдер вложенной фичи "Пуш-уведомления в приложении".
    init(dependency: AppDependency,
         navigationController: UINavigationController?,
         mainWordListBuilder: MainWordListBuilder,
         pushNotificationBuilder: PushNotificationBuilder) {
        self.dependency = dependency

        let mainWordListViewController = mainWordListBuilder.build()

        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.setViewControllers([mainWordListViewController], animated: false)

        rootViewController = navigationController
        pushNotificationService = pushNotificationBuilder.build()
    }
}

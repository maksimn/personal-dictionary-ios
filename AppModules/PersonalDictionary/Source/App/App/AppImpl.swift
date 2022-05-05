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
    private(set) var navigationController: UINavigationController?

    /// Инициализатор:
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - mainWordListBuilder: билдер вложенной фичи "Главный список слов".
    init(navigationController: UINavigationController?,
         mainWordListBuilder: MainWordListBuilder) {
        let mainWordListViewController = mainWordListBuilder.build()

        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.setViewControllers([mainWordListViewController], animated: false)

        self.navigationController = navigationController
    }
}

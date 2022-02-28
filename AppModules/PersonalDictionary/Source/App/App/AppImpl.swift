//
//  AppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Общий протокол из базовых зависимостей в приложении.
protocol BaseDependency {

    /// Корневой navigation controller приложения.
    var navigationController: UINavigationController? { get }

    /// Конфигурация приложения.
    var appConfig: Config { get }
}

/// Реализация приложения "Личный словарь иностранных слов".
final class AppImpl: App, BaseDependency {

    /// Получение корневого контроллера приложения
    let navigationController: UINavigationController? = UINavigationController()

    /// Конфигурация приложения.
    let appConfig: Config

    /// Инициализатор:
    /// - Parameters:
    ///  - config: конфигурация приложения.
    init(config: Config) {
        self.appConfig = config

        let mainWordListBuilder = MainWordListBuilderImpl(dependency: self)
        let mainWordListViewController = mainWordListBuilder.build()

        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.setViewControllers([mainWordListViewController], animated: false)
    }
}

extension AppImpl: MainWordListDependency { }

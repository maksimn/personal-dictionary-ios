//
//  AppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import CoreModule
import UIKit

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class AppBuilderImpl: AppBuilder {

    private lazy var logger = LoggerImpl(category: "PersonalDictionary.App")

    public init() { }

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        let dependency = appDependency()
        let app = App(
            rootViewController: rootViewController(dependency),
            pushNotificationService: pushNotificationService(dependency)
        )

        logger.log(installedFeatureName: "App")

        return app
    }

    private func appDependency() -> AppDependency {
        let appConfigFactory = AppConfigFactory()
        let appConfig = appConfigFactory.create()

        logger.debug("App Config has been created.")

        return AppDependencyImpl(
            navigationController: UINavigationController(), appConfig: appConfig, bundle: Bundle.module
        )
    }

    private func rootViewController(_ dependency: AppDependency) -> UIViewController {
        let navigationController = dependency.navigationController
        let mainScreenBuilder = MainScreenBuilder(dependency: dependency)
        let mainScreen = mainScreenBuilder.build()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([mainScreen], animated: false)

        return navigationController
    }

    private func pushNotificationService(_ dependency: AppDependency) -> PushNotificationService {
        let pushNotificationBuilder = PushNotificationBuilderImpl(dependency: dependency)

        return pushNotificationBuilder.build()
    }
}

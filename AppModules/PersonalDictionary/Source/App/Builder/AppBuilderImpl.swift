//
//  AppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class AppBuilderImpl: AppBuilder {

    public init() { }

    private lazy var dependency: AppDependency = appDependency()

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        return AppImpl(
            rootViewController: rootViewController(dependency),
            pushNotificationService: pushNotificationService(dependency)
        )
    }

    private func appDependency() -> AppDependency {
        let bundle = Bundle(for: type(of: self))
        let appConfigFactory = AppConfigFactory(bundle: bundle)
        let navigationController = UINavigationController()
        let appConfig = appConfigFactory.create()

        return AppDependencyImpl(
            navigationController: navigationController,
            appConfig: appConfig,
            bundle: bundle
        )
    }

    private func rootViewController(_ dependency: AppDependency) -> UIViewController {
        guard let navigationController = dependency.navigationController else { return UIViewController() }
        let mainScreenBuilder = MainScreenBuilder(dependency: dependency)
        let mainScreen = mainScreenBuilder.build()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([mainScreen], animated: false)

        return navigationController
    }

    private func pushNotificationService(_ dependency: AppDependency) -> PushNotificationService {
        let pushNotificationBuilder = PushNotificationBuilderImpl(dependency: dependency)

        return pushNotificationBuilder.build()
    }
}

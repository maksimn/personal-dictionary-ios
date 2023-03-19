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

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        let dependency = appDependency()

        return App(
            rootViewController: rootViewController(dependency),
            pushNotificationService: pushNotificationService(dependency)
        )
    }

    private func appDependency() -> AppDependency {
        let bundle = Bundle(for: type(of: self))
        let appConfigFactory = AppConfigFactory(bundle: bundle)

        return AppDependencyImpl(
            navigationController: UINavigationController(),
            appConfig: appConfigFactory.create(),
            bundle: bundle
        )
    }

    private func rootViewController(_ dependency: AppDependency) -> UIViewController {
        let navigationController = dependency.navigationController
        let mainWordListBuilder = MainWordListBuilder(dependency: dependency)
        let mainWordList = mainWordListBuilder.build()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([mainWordList], animated: false)

        return navigationController
    }

    private func pushNotificationService(_ dependency: AppDependency) -> PushNotificationService {
        let pushNotificationBuilder = PushNotificationBuilderImpl(dependency: dependency)

        return pushNotificationBuilder.build()
    }
}

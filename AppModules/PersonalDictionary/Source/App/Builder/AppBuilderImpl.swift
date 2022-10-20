//
//  AppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

protocol AppDependency: AnyObject {

    var navigationController: UINavigationController? { get }

    var appConfig: AppConfig { get }
    
    var bundle: Bundle { get }
}

class AppDependencyImpl: AppDependency {

    private(set) weak var navigationController: UINavigationController?

    let appConfig: AppConfig

    let bundle: Bundle

    init(
        navigationController: UINavigationController?,
        appConfig: AppConfig,
        bundle: Bundle
    ) {
        self.navigationController = navigationController
        self.appConfig = appConfig
        self.bundle = bundle
    }
}

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class AppBuilderImpl: AppBuilder {

    public init() { }

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        let bundle = Bundle(for: type(of: self))
        let appConfigFactory = AppConfigFactory(variant: .development, bundle: bundle)
        let navigationController = UINavigationController()
        let appConfig = appConfigFactory.create()
        let dependency = AppDependencyImpl(
            navigationController: navigationController,
            appConfig: appConfig,
            bundle: bundle
        )

        return AppImpl(
            dependency: dependency,
            mainWordListBuilder: MainWordListBuilderImpl(dependency: dependency),
            pushNotificationBuilder: PushNotificationBuilderImpl(dependency: dependency)
        )
    }
}

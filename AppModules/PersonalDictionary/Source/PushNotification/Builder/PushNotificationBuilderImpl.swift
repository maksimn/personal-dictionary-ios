//
//  PushNotificationBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2022.
//

import UserNotifications
import CoreModule

protocol PushNotificationDependency: BaseDependency { }

final class PushNotificationBuilderImpl: PushNotificationBuilder {

    private let appConfig: AppConfig
    private weak var navigationController: UINavigationController?

    init(dependency: PushNotificationDependency) {
        appConfig = dependency.appConfig
        navigationController = dependency.navigationController
    }

    func build() -> PushNotificationService {
        let langRepository = LangRepositoryImpl(
            userDefaults: UserDefaults.standard,
            data: appConfig.langData
        )
        let newWordBuilder = NewWordBuilderImpl(
            bundle: appConfig.bundle,
            langRepository: langRepository
        )

        return PushNotificationServiceImpl(
            userNotificationCenter: UNUserNotificationCenter.current(),
            datetimeCalculator: NextHHMMDatetimeCalculator(),
            navToNewWordRouter: NavToNewWordRouterImpl(
                navigationController: navigationController,
                newWordBuilder: newWordBuilder
            ),
            bundle: appConfig.bundle,
            logger: LoggerImpl(isLoggingEnabled: appConfig.isLoggingEnabled)
        )
    }
}

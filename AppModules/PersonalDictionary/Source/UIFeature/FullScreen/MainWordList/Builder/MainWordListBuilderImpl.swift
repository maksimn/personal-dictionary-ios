//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Общий протокол из базовых зависимостей в приложении.
protocol BaseDependency {

    var navigationController: UINavigationController { get }

    var appConfig: Config { get }

    var logger: Logger { get }

    var wordListRepository: WordListRepository { get }
}

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder, BaseDependency {

    private lazy var bundle = Bundle(for: type(of: self))

    let navigationController = UINavigationController()

    let appConfig: Config

    var logger: Logger {
        LoggerImpl(isLoggingEnabled: appConfig.isLoggingEnabled)
    }

    var wordListRepository: WordListRepository {
        CoreWordListRepository(
            args: CoreWordListRepositoryArgs(bundle: bundle,
                                             persistentContainerName: "StorageModel"),
            langRepository: langRepository,
            logger: logger
        )
    }

    private(set) lazy var langRepository: LangRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                                              data: appConfig.langData)

    /// Инициализатор.
    /// - Parameters:
    ///  - config: конфигурация приложения.
    init(config: Config) {
        appConfig = config
    }

    /// Создать объекты фичи.
    /// - Returns:
    ///  - Navigation controller с проинициализированным экраном  "Главного (основного) списка слов".
    func build() -> UINavigationController {
        let viewController = MainWordListViewController(
            viewParams: createViewParams(),
            wordListBuilder: createWordListBuilder(),
            wordListFetcher: wordListRepository,
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: self)
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([viewController], animated: false)

        return navigationController
    }

    private func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }

    private func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            params: WordListParams(shouldAnimateWhenAppear: true),
            dependency: self
        )
    }
}

/// Для передачи зависимостей во вложенные фичи.
extension MainWordListBuilderImpl: WordListDependency, MainNavigatorDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

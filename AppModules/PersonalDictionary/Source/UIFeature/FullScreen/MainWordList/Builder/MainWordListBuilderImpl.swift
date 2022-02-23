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
    ///  - config:
    init(config: Config) {
        appConfig = config
    }

    /// Создать граф фичи.
    /// - Returns:
    ///  - Граф фичи "Главный (основной) список слов".
    func build() -> MainWordListGraph {
        MainWordListGraphImpl(
            viewParams: createViewParams(),
            navigationController: navigationController,
            navToSearchBuilder: NavToSearchBuilderImpl(width: .full, dependency: self),
            headerBuilder: MainWordListHeaderBuilderImpl(dependency: self),
            wordListBuilder: WordListBuilderImpl(params: WordListParams(shouldAnimateWhenAppear: true),
                                                 dependency: self),
            wordListFetcher: wordListRepository,
            newWordBuilder: NewWordBuilderImpl(dependency: self),
            coreRouter: appConfig.appParams.coreRouter
        )
    }

    private func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
            routingButtonTitle: appConfig.appParams.routingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }
}

/// Для передачи зависимостей во вложенные фичи.
extension MainWordListBuilderImpl: WordListDependency,
                                   NavToSearchDependency,
                                   NewWordDependency,
                                   MainWordListHeaderDependency {

    var cudOperations: WordItemCUDOperations {
        wordListRepository
    }
}

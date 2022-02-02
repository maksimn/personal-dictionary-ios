//
//  MainWordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

/// Зависимости фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListDependencies: MainWordListExternals {

    private(set) var appConfig: AppConfigs

    private lazy var bundle = Bundle(for: type(of: self))

    fileprivate lazy var _langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                              data: appConfig.langData)

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: параметры конфигурации приложения.
    init(externals: MainWordListExternals) {
        self.appConfig = externals.appConfig
    }

    /// Создать параметры представления Главного списка слов.
    func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
            routingButtonTitle: appConfig.appParams.routingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height)),
            backgroundColor: appConfig.appViewConfigs.backgroundColor
        )
    }

    /// Создать билдер фичи "Добавление нового слова" в словарь.
    func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(externals: self)
    }

    /// Создать билдер фичи "Список слов".
    func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            params: WordListParams(shouldAnimateWhenAppear: true),
            externals: self
        )
    }

    /// Создать билдер фичи "Поиск" по словам в словаре.
    func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(externals: self)
    }

    /// Создать хранилище слов Личного словаря.
    func createWordListRepository() -> WordListRepository {
        return CoreWordListRepository(
            args: CoreWordListRepositoryArgs(
                bundle: bundle,
                persistentContainerName: "StorageModel"
            ),
            langRepository: _langRepository,
            logger: createLogger()
        )
    }

    fileprivate func createLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: appConfig.isLoggingEnabled)
    }
}

/// Для передачи внешних зависимостей в фичу "Список слов".
extension MainWordListDependencies: WordListExternals {

    var cudOperations: WordItemCUDOperations {
        createWordListRepository()
    }

    var logger: Logger {
        createLogger()
    }
}

/// Для передачи внешних зависимостей в фичу "Поиск по словам Личного словаря".
extension MainWordListDependencies: SearchExternals {

    var wordListFetcher: WordListFetcher {
        createWordListRepository()
    }
}

/// Для передачи внешних зависимостей в фичу "Добавление нового слова" в Личный словарь.
extension MainWordListDependencies: NewWordExternals {

    var appViewConfigs: AppViewConfigs {
        appConfig.appViewConfigs
    }

    var langRepository: LangRepository {
        _langRepository
    }
}

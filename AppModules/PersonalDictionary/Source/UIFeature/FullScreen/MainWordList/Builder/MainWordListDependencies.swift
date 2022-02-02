//
//  MainWordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

/// Зависимости фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListDependencies {

    fileprivate let externals: MainWordListExternals

    private lazy var bundle = Bundle(for: type(of: self))

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: параметры конфигурации приложения.
    init(externals: MainWordListExternals) {
        self.externals = externals
    }

    /// Создать параметры представления Главного списка слов.
    func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
            routingButtonTitle: externals.appConfig.appParams.routingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height)),
            backgroundColor: externals.appConfig.appViewConfigs.backgroundColor
        )
    }

    /// Создать билдер фичи "Добавление нового слова" в словарь.
    func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(
            appViewConfigs: externals.appConfig.appViewConfigs,
            langRepository: createLangRepository()
        )
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
            langRepository: createLangRepository(),
            logger: createLogger()
        )
    }

    fileprivate func createLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: externals.appConfig.isLoggingEnabled)
    }

    private func createLangRepository() -> LangRepository {
        LangRepositoryImpl(
            userDefaults: UserDefaults.standard,
            data: externals.appConfig.langData
        )
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

    var appConfig: AppConfigs {
        externals.appConfig
    }
}

/// Для передачи внешних зависимостей в фичу "Поиск по словам Личного словаря".
extension MainWordListDependencies: SearchExternals {

    var wordListFetcher: WordListFetcher {
        createWordListRepository()
    }
}

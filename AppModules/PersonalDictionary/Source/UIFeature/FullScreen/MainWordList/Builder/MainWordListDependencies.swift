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

    private(set) lazy var langRepository: LangRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
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
            backgroundColor: Theme.data.backgroundColor
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
            args: CoreWordListRepositoryArgs(bundle: bundle,
                                             persistentContainerName: "StorageModel"),
            langRepository: langRepository,
            logger: logger
        )
    }

    var logger: Logger {
        SimpleLogger(isLoggingEnabled: appConfig.isLoggingEnabled)
    }
}

/// Для передачи внешних зависимостей в фичу "Список слов".
extension MainWordListDependencies: WordListExternals {

    var cudOperations: WordItemCUDOperations {
        createWordListRepository()
    }
}

/// Для передачи внешних зависимостей в фичу "Поиск по словам Личного словаря".
extension MainWordListDependencies: SearchExternals {

    var wordListRepository: WordListRepository {
        createWordListRepository()
    }
}

/// Для передачи внешних зависимостей в фичу "Добавление нового слова" в Личный словарь.
extension MainWordListDependencies: NewWordExternals {

}

//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Внешние зависимости фичи "Главный (основной) список слов" Личного словаря.
protocol MainWordListExternals {

    /// Конфигурация приложения
    var appConfig: AppConfigs { get }
}

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder {

    private lazy var bundle = Bundle(for: type(of: self))

    let appConfig: AppConfigs

    var logger: Logger {
        LoggerImpl(isLoggingEnabled: appConfig.isLoggingEnabled)
    }

    private(set) lazy var langRepository: LangRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                                              data: appConfig.langData)

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: MainWordListExternals) {
        appConfig = externals.appConfig
    }

    /// Создать граф фичи.
    /// - Returns:
    ///  - Граф фичи "Главный (основной) список слов".
    func build() -> MainWordListGraph {
        MainWordListGraphImpl(
            viewParams: createViewParams(),
            wordListBuilder: WordListBuilderImpl(params: WordListParams(shouldAnimateWhenAppear: true),
                                                 externals: self),
            wordListFetcher: createWordListRepository(),
            newWordBuilder: NewWordBuilderImpl(externals: self),
            searchBuilder: SearchBuilderImpl(externals: self),
            coreRouter: appConfig.appParams.coreRouter
        )
    }

    private func createViewParams() -> MainWordListViewParams {
        MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
            routingButtonTitle: appConfig.appParams.routingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        )
    }

    private func createWordListRepository() -> WordListRepository {
        CoreWordListRepository(
            args: CoreWordListRepositoryArgs(bundle: bundle,
                                             persistentContainerName: "StorageModel"),
            langRepository: langRepository,
            logger: logger
        )
    }
}

/// Для передачи внешних зависимостей в фичу "Список слов".
extension MainWordListBuilderImpl: WordListExternals {

    var cudOperations: WordItemCUDOperations {
        createWordListRepository()
    }
}

/// Для передачи внешних зависимостей в фичу "Поиск по словам Личного словаря".
extension MainWordListBuilderImpl: SearchExternals {

    var wordListRepository: WordListRepository {
        createWordListRepository()
    }
}

/// Для передачи внешних зависимостей в фичу "Добавление нового слова" в Личный словарь.
extension MainWordListBuilderImpl: NewWordExternals { }

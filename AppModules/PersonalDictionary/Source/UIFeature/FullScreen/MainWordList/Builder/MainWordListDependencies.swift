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

    /// Параметры представления Главного списка слов
    private(set) lazy var viewParams = MainWordListViewParams(
        heading: bundle.moduleLocalizedString("My dictionary"),
        navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
        routingButtonTitle: appConfigs.appParams.routingButtonTitle,
        visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height)),
        backgroundColor: appConfigs.appViewConfigs.backgroundColor
    )

    /// Хранилище слов из личного словаря.
    private(set) lazy var wordListRepository = buildWordListRepository()

    private lazy var bundle = Bundle(for: type(of: self))

    private let appConfigs: AppConfigs

    private lazy var langRepository = buildLangRepository()

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: параметры конфигурации приложения.
    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    /// Создать билдер фичи "Поиск".
    /// - Returns:
    ///  -  билдер фичи "Поиск".
    func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(
            wordListConfigs: WordListConfigs(
                appConfigs: appConfigs,
                shouldAnimateWhenAppear: false
            ),
            wordListRepository: wordListRepository
        )
    }

    /// Создать билдер фичи "Добавление нового слова".
    /// - Returns:
    ///  - билдер фичи "Добавление нового слова".
    func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                           langRepository: langRepository)
    }

    /// Создать билдер фичи "Список слов".
    /// - Returns:
    ///  -  билдер фичи "Список слов"..
    func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(
            configs: WordListConfigs(
                appConfigs: appConfigs,
                shouldAnimateWhenAppear: true
            ),
            cudOperations: wordListRepository
        )
    }

    private func buildLangRepository() -> LangRepository {
        return LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                  data: appConfigs.langData)
    }

    private func buildLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: appConfigs.isLoggingEnabled)
    }

    private func buildWordListRepository() -> WordListRepository {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(bundle: bundle,
                                                                    persistentContainerName: "StorageModel")

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: langRepository,
                                      logger: buildLogger())
    }
}

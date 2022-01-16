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
        backgroundColor: appConfigs.appViewConfigs.backgroundColor,
        navToNewWordButtonSize: CGSize(width: 44, height: 44),
        navToNewWordButtonBottomOffset: -26
    )

    private lazy var bundle = Bundle(for: type(of: self))

    private let appConfigs: AppConfigs

    private lazy var langRepository = buildLangRepository()

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: параметры конфигурации приложения.
    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    /// Создать хранилище слов из личного словаря.
    /// - Returns:
    ///  -  хранилище слов.
    func buildWordListRepository() -> WordListRepository {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(bundle: bundle,
                                                                    persistentContainerName: "StorageModel")

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: langRepository,
                                      logger: buildLogger())
    }

    /// Создать билдер фичи "Поиск".
    /// - Returns:
    ///  -  билдер фичи "Поиск".
    func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                          wordListFetcher: buildWordListRepository(),
                          wordListBuilder: createWordListBuilder())
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
        WordListBuilderImpl(appConfigs: appConfigs,
                            cudOperations: buildWordListRepository())
    }

    private func buildLangRepository() -> LangRepository {
        return LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                  data: appConfigs.langData)
    }

    private func buildLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: appConfigs.isLoggingEnabled)
    }
}

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

    /// Параметры представления Главного списка слов.
    let viewParams: MainWordListViewParams

    /// Билдер фичи "Список слов".
    let wordListBuilder: WordListBuilder

    /// Источник данных для получения списка слов из хранилища.
    let wordListFetcher: WordListFetcher

    /// Билдер фичи "Добавление нового слова" в словарь.
    let newWordBuilder: NewWordBuilder

    /// Билдер фичи "Поиск" по словам в словаре.
    let searchBuilder: SearchBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: параметры конфигурации приложения.
    init(appConfigs: AppConfigs) {
        let bundle = Bundle(for: type(of: self))
        let logger = SimpleLogger(isLoggingEnabled: appConfigs.isLoggingEnabled)
        let langRepository =  LangRepositoryImpl(
            userDefaults: UserDefaults.standard,
            data: appConfigs.langData
        )
        let wordListRepository = CoreWordListRepository(
            args: CoreWordListRepositoryArgs(
                bundle: bundle,
                persistentContainerName: "StorageModel"
            ),
            langRepository: langRepository,
            logger: logger
        )

        viewParams = MainWordListViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
            routingButtonTitle: appConfigs.appParams.routingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height)),
            backgroundColor: appConfigs.appViewConfigs.backgroundColor
        )

        let wordListExternals = WordListExternals(
            appConfigs: appConfigs,
            cudOperations: wordListRepository,
            logger: logger
        )

        wordListBuilder = WordListBuilderImpl(
            params: WordListParams(shouldAnimateWhenAppear: true),
            externals: wordListExternals
        )

        wordListFetcher = wordListRepository

        newWordBuilder = NewWordBuilderImpl(
            appViewConfigs: appConfigs.appViewConfigs,
            langRepository: langRepository
        )

        searchBuilder = SearchBuilderImpl(
            externals: SearchExternals(
                wordListFetcher: wordListRepository,
                wordListExternals: wordListExternals
            )
        )
    }
}

//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder {

    private let appConfigs: AppConfigs

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: параметры конфигурации приложения.
    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    /// Создать граф фичи.
    /// - Returns:
    ///  - Граф фичи  "Главный (основной) список слов".
    func build() -> MainWordListGraph {
        let dependencies = MainWordListDependencies(appConfigs: appConfigs)

        return MainWordListGraphImpl(viewParams: dependencies.viewParams,
                                     wordListBuilder: dependencies.createWordListBuilder(),
                                     wordListFetcher: dependencies.buildWordListRepository(),
                                     newWordBuilder: dependencies.createNewWordBuilder(),
                                     searchBuilder: dependencies.createSearchBuilder(),
                                     coreRouter: appConfigs.appParams.coreRouter)
    }
}

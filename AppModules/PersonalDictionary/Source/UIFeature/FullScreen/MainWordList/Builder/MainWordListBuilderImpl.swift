//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Внешние зависимости фичи "Главный (основной) список слов" Личного словаря.
protocol MainWordListExternals {

    /// Конфигурация приложения
    var appConfig: AppConfigs { get }
}

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilderImpl: MainWordListBuilder {

    private let externals: MainWordListExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - externals: внешние зависимости фичи.
    init(externals: MainWordListExternals) {
        self.externals = externals
    }

    /// Создать граф фичи.
    /// - Returns:
    ///  - Граф фичи "Главный (основной) список слов".
    func build() -> MainWordListGraph {
        let dependencies = MainWordListDependencies(externals: externals)

        return MainWordListGraphImpl(
            viewParams: dependencies.createViewParams(),
            wordListBuilder: dependencies.createWordListBuilder(),
            wordListFetcher: dependencies.createWordListRepository(),
            newWordBuilder: dependencies.createNewWordBuilder(),
            searchBuilder: dependencies.createSearchBuilder(),
            coreRouter: externals.appConfig.appParams.coreRouter
        )
    }
}

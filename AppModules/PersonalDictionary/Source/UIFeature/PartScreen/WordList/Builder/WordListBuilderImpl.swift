//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Список слов".
final class WordListBuilderImpl: WordListBuilder {

    private let appConfigs: AppConfigs
    private let cudOperations: WordItemCUDOperations

    /// Инициализатор.
    /// - Parameters:
    ///  - appConfigs: конфигурация  приложения.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    init(appConfigs: AppConfigs,
         cudOperations: WordItemCUDOperations) {
        self.appConfigs = appConfigs
        self.cudOperations = cudOperations
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM {
        let dependencies = WordListDependencies(appConfigs: appConfigs)

        return WordListMVVMImpl(cudOperations: cudOperations,
                                translationService: dependencies.translationService,
                                wordItemStream: dependencies.wordItemStream,
                                viewParams: dependencies.viewParams)
    }
}

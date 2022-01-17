//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Конфигурация списка слов, которую можно задать в клиентском коде.
struct WordListConfigs {

    /// Конфигурация приложения
    let appConfigs: AppConfigs

    /// Запускать ли анимацию при первом появлении данных в таблице.
    let shouldAnimateWhenAppear: Bool
}

/// Реализация билдера фичи "Список слов".
final class WordListBuilderImpl: WordListBuilder {

    private let configs: WordListConfigs
    private let cudOperations: WordItemCUDOperations

    /// Инициализатор.
    /// - Parameters:
    ///  - configs: конфигурация списка слов.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    init(configs: WordListConfigs,
         cudOperations: WordItemCUDOperations) {
        self.configs = configs
        self.cudOperations = cudOperations
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM {
        let dependencies = WordListDependencies(configs: configs)

        return WordListMVVMImpl(cudOperations: cudOperations,
                                translationService: dependencies.translationService,
                                wordItemStream: dependencies.wordItemStream,
                                viewParams: dependencies.viewParams)
    }
}

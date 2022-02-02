//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Параметры списка слов, которые можно задать в клиентском коде.
struct WordListParams {

    /// Запускать ли анимацию при первом появлении данных в таблице.
    let shouldAnimateWhenAppear: Bool
}

/// Реализация билдера фичи "Список слов".
final class WordListBuilderImpl: WordListBuilder {

    private let params: WordListParams
    private let externals: WordListExternals

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры списка слов.
    ///  - externals: внешние зависимости.
    init(params: WordListParams,
         externals: WordListExternals) {
        self.params = params
        self.externals = externals
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM {
        let dependencies = WordListDependencies(
            params: params,
            externals: externals
        )

        return WordListMVVMImpl(cudOperations: externals.cudOperations,
                                translationService: dependencies.translationService,
                                wordItemStream: dependencies.wordItemStream,
                                viewParams: dependencies.viewParams)
    }
}

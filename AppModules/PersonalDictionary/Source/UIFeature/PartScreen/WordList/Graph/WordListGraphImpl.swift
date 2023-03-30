//
//  WordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import UIKit

/// Реализация графа фичи "Список слов".
final class WordListGraphImpl: WordListGraph {

    let view: UIView

    let viewModel: WordListViewModel

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления фичи.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    ///  - translationService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordStream: ModelStream для событий со словами в личном словаре.
    init(viewParams: WordListViewParams,
         cudOperations: WordCUDOperations,
         translationService: TranslationService,
         wordStream: WordStream,
         logger: Logger) {
        let model = WordListModelImpl(
            cudOperations: cudOperations,
            wordSender: wordStream,
            translationService: translationService
        )
        viewModel = WordListViewModelImpl(
            model: model,
            wordStream: wordStream,
            logger: logger
        )
        view = WordListView(
            viewModel: viewModel,
            params: viewParams,
            theme: Theme.data,
            logger: logger
        )
    }
}

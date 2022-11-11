//
//  WordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Реализация графа фичи "Список слов".
final class WordListGraphImpl: WordListGraph {

    /// View controller для показа экрана/части экрана со списком слов
    private(set) var viewController: UIViewController

    /// Модель списка слов
    private(set) weak var model: WordListModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления фичи.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    ///  - translationService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordStream: ModelStream для событий со словами в личном словаре.
    init(viewParams: WordListViewParams,
         cudOperations: WordCUDOperations,
         translationService: TranslationService,
         wordStream: WordStream) {
        weak var viewModelLazy: WordListViewModel?

        let model = WordListModelImpl(
            viewModelBlock: { viewModelLazy },
            cudOperations: cudOperations,
            translationService: translationService,
            wordStream: wordStream
        )
        let viewModel = WordListViewModelImpl(model: model)
        let view = WordListViewController(
            viewModel: viewModel,
            params: viewParams
        )

        viewModelLazy = viewModel

        viewController = view
        self.model = model
    }
}

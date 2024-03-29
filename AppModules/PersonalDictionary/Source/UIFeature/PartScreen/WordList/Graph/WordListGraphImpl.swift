//
//  WordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import UIKit

/// Реализация графа фичи "Список слов".
final class WordListGraphImpl<RouterType: ParametrizedRouter>: WordListGraph where RouterType.Parameter == Word.Id {

    let view: UIView

    let viewModel: WordListViewModel

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления фичи.
    ///  - wordStream: ModelStream для событий со словами в личном словаре.
    init(
        viewParams: WordListViewParams,
        wordStream: WordStream,
        updateWordDbWorker: UpdateWordDbWorker,
        deleteWordDbWorker: DeleteWordDbWorker,
        router: RouterType,
        logger: Logger
    ) {
        let model = WordListModelImpl(
            updateWordDbWorker: updateWordDbWorker,
            deleteWordDbWorker: deleteWordDbWorker,
            wordSender: wordStream
        )
        viewModel = WordListViewModelImpl(
            model: model,
            wordStream: wordStream,
            router: router,
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

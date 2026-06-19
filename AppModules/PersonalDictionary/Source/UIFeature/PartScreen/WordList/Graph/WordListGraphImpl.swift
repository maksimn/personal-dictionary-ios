//
//  WordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import UIKit

/// Implementation of the "Word List" feature graph.
final class WordListGraphImpl<RouterType: ParametrizedRouter>: WordListGraph where RouterType.Parameter == Word.Id {

    let view: UIView

    let viewModel: WordListViewModel

    /// Initializer.
    /// - Parameters:
    ///  - viewParams: feature view parameters.
    init(
        viewParams: WordListViewParams,
        updateWordDbWorker: UpdateWordDbWorker,
        deleteWordDbWorker: DeleteWordDbWorker,
        router: RouterType,
        updatedWordStream: UpdatedWordStream & UpdatedWordSender,
        removedWordStream: RemovedWordStream & RemovedWordSender,
        logger: Logger
    ) {
        let model = WordListModelImpl(
            updateWordDbWorker: updateWordDbWorker,
            deleteWordDbWorker: deleteWordDbWorker,
            updatedWordSender: updatedWordStream,
            removedWordSender: removedWordStream
        )
        viewModel = WordListViewModelImpl(
            model: model,
            updatedWordStream: updatedWordStream,
            removedWordStream: removedWordStream,
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

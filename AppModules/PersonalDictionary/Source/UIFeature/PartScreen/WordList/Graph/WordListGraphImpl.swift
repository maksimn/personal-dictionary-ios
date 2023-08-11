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
    ///  - dictionaryService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordStream: ModelStream для событий со словами в личном словаре.
    init(
        appDependency: AppDependency,
        viewParams: WordListViewParams,
        wordStream: WordStream,
        logger: Logger
    ) {
        let model = WordListModelImpl(
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            deleteWordDbWorker: DeleteWordDbWorkerImpl(),
            wordSender: wordStream
        )
        let router = NavToDictionaryEntryRouter(
            navigationController: appDependency.navigationController,
            builder: DictionaryEntryBuilder(bundle: appDependency.bundle)
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

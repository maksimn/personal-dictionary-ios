//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import UIKit

/// Реализация MVVM-графа фичи "Список слов".
final class WordListMVVMImpl: WordListMVVM {

    /// View controller для показа экрана/части экрана со списком слов
    private(set) var viewController: UIViewController

    /// Модель списка слов
    private(set) weak var model: WordListModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    ///  - translationService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordItemStream: ModelStream для событий со словами в личном словаре.
    ///  - viewParams: параметры представления фичи.
    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: ReadableWordItemStream & RemovedWordItemStream,
         viewParams: WordListViewParams) {
        weak var viewModelLazyWeak: WordListViewModel?
        var viewModelLazy: WordListViewModel?

        let view = WordListViewController(viewModelBlock: { viewModelLazy },
                                          params: viewParams)
        let model = WordListModelImpl(viewModelBlock: { viewModelLazyWeak },
                                      cudOperations: cudOperations,
                                      translationService: translationService,
                                      wordItemStream: wordItemStream)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        viewModelLazyWeak = viewModel
        viewModelLazy = viewModel

        viewController = view
        self.model = model
    }
}

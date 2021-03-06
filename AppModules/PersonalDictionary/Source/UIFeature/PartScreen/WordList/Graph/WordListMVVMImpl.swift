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
    ///  - viewParams: параметры представления фичи.
    ///  - cudOperations: сервис для операций create, update, delete со словами в хранилище личного словаря.
    ///  - translationService: cлужба для выполнения перевода слов на целевой язык.
    ///  - wordItemStream: ModelStream для событий со словами в личном словаре.
    init(viewParams: WordListViewParams,
         cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: WordItemStream) {
        weak var viewModelLazyWeak: WordListViewModel?

        let model = WordListModelImpl(viewModelBlock: { viewModelLazyWeak },
                                      cudOperations: cudOperations,
                                      translationService: translationService,
                                      wordItemStream: wordItemStream)
        let viewModel = WordListViewModelImpl(model: model)
        let view = WordListViewController(viewModel: viewModel,
                                          params: viewParams)

        viewModelLazyWeak = viewModel

        viewController = view
        self.model = model
    }
}

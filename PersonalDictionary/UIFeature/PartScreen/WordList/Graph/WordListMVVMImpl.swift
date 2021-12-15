//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordListMVVMImpl: WordListMVVM {

    private var view: WordListViewController

    weak var model: WordListModel?

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         wordItemStream: ReadableWordItemStream & RemovedWordItemStream,
         viewParams: WordListViewParams,
         logger: Logger) {
        weak var viewModelLazyWeak: WordListViewModel?
        var viewModelLazy: WordListViewModel?

        view = WordListViewController(viewModelBlock: { viewModelLazy },
                                      params: viewParams)
        let model = WordListModelImpl(viewModelBlock: { viewModelLazyWeak },
                                      cudOperations: cudOperations,
                                      translationService: translationService,
                                      wordItemStream: wordItemStream,
                                      logger: logger)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        viewModelLazyWeak = viewModel
        viewModelLazy = viewModel
        self.model = model
    }

    var viewController: UIViewController {
        view
    }
}

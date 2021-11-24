//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordListMVVMImpl: WordListMVVM {

    private var view: WordListViewController?

    weak var model: WordListModel?

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         notificationCenter: NotificationCenter,
         viewParams: WordListViewParams,
         logger: Logger) {
        view = WordListViewController(params: viewParams)
        guard let view = view else { return }
        weak var viewModelLazy: WordListViewModel?
        let model = WordListModelImpl(viewModelBlock: { viewModelLazy },
                                      cudOperations: cudOperations,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter,
                                      logger: logger)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        viewModelLazy = viewModel
        view.viewModel = viewModel
        self.model = model
    }

    var viewController: UIViewController? {
        view
    }
}

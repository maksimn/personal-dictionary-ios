//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

class WordListMVVMImpl: WordListMVVM {

    private var view: WordListViewController?

    weak var model: WordListModel?

    init() {
        view = nil
        model = nil
    }

    init(cudOperations: WordListCUDOperations,
         translationService: TranslationService,
         notificationCenter: NotificationCenter,
         viewParams: WordListViewParams) {
        view = WordListViewController(params: viewParams)
        guard let view = view else { return }
        let model = WordListModelImpl(cudOperations: cudOperations,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        self.model = model
    }

    var viewController: UIViewController? {
        view
    }
}

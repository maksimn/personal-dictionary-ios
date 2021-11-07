//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

class WordListMVVMImpl: WordListMVVM {

    private var view: WordListViewController?

    init() {
        view = nil
    }

    init(router: Router,
         wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter,
         viewParams: WordListViewParams) {
        view = WordListViewController(params: viewParams)
        guard let view = view else { return }
        let model = WordListModelImpl(wordListRepository: wordListRepository,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter)
        let viewModel = WordListViewModelImpl(model: model, view: view, router: router)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }

    var navigationController: UINavigationController? {
        view?.navigationController
    }
}

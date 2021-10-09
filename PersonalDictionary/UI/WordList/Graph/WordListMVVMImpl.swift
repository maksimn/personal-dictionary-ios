//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordListMVVMImpl<TService: TranslationService>: WordListMVVM
    where TService.Success == [PonsResponseData] {

    private let view: WordListViewController

    init(wordListRepository: WordListRepository,
         translationService: TService,
         notificationCenter: NotificationCenter) {
        view = WordListViewController()
        let model = WordListModelImpl(wordListRepository: wordListRepository,
                                      translationService: translationService,
                                      notificationCenter: notificationCenter)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}

//
//  WordListMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordListMVVMImpl: WordListMVVM {

    private let view: WordListViewController

    init(wordListRepository: WordListRepository,
         notificationCenter: NotificationCenter) {
        view = WordListViewController()
        let model = WordListModelImpl(wordListRepository: wordListRepository,
                                      notificationCenter: notificationCenter)
        let viewModel = WordListViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}

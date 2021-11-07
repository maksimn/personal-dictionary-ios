//
//  SearchWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class SearchWordMVVMImpl: WordListMVVMImpl {

    private var viewOne: SearchWordViewController?

    init(wordListRepository: WordListRepository,
         translationService: TranslationService,
         notificationCenter: NotificationCenter,
         viewParams: SearchWordViewParams) {
        super.init()
        viewOne = SearchWordViewController(params: viewParams)
        guard let viewOne = viewOne else { return }
        let model = SearchWordModelImpl(wordListRepository: wordListRepository,
                                        translationService: translationService,
                                        notificationCenter: notificationCenter)
        let viewModel = SearchWordViewModelImpl(model: model, view: viewOne)

        viewOne.viewModel = viewModel
        model.viewModel = viewModel
    }

    override var viewController: UIViewController? {
        viewOne
    }
}

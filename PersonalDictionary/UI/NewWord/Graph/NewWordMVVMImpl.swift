//
//  NewWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class NewWordMVVMImpl: NewWordMVVM {

    private let view: NewWordViewController

    init(langRepository: LangRepository,
         notificationCenter: NotificationCenter,
         viewParams: NewWordViewParams) {
        view = NewWordViewController(params: viewParams)
        let model = NewWordModelImpl(langRepository, notificationCenter)
        let viewModel = NewWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}

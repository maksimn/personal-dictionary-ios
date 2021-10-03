//
//  NewWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class NewWordMVVMImpl: NewWordMVVM {

    private let view: NewWordViewController

    init(langRepository: LangRepository, viewResource: NewWordViewResource) {
        view = NewWordViewController(viewResource: viewResource)
        let model = NewWordModelImpl(langRepository)
        let viewModel = NewWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}

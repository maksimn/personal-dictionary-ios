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
         listener: NewWordListener?,
         viewParams: NewWordViewParams,
         langPickerBuilder: LangPickerBuilder) {
        view = NewWordViewController(params: viewParams, langPickerBuilder: langPickerBuilder)
        let model = NewWordModelImpl(langRepository, listener)
        let viewModel = NewWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        model.bindInitially()
    }

    var viewController: UIViewController? {
        view
    }
}

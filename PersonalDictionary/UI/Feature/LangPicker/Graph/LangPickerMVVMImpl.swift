//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerMVVMImpl: LangPickerMVVM {

    private let view: LangPickerViewImpl

    var uiview: UIView? {
        view
    }

    weak var model: LangPickerModel?

    init(allLangs: [Lang],
         viewParams: LangPickerViewParams) {
        view = LangPickerViewImpl(params: viewParams, allLangs: allLangs)
        let model = LangPickerModelImpl()
        let viewModel = LangPickerViewModelImpl(model: model, view: view)

        model.viewModel = viewModel
        view.viewModel = viewModel
        self.model = model
    }
}

//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerMVVMImpl: LangPickerMVVM {

    private let view: LangPickerViewImpl

    init(with data: LangSelectorData) {
        view = LangPickerViewImpl()
        let model = LangPickerModelImpl(data: data)
        let viewModel = LangPickerViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var uiview: UIView? {
        view
    }
}

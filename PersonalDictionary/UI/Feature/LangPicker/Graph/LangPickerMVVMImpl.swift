//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerMVVMImpl: LangPickerMVVM {

    private let view: LangPickerViewImpl

    init(with data: LangSelectorData,
         notificationCenter: NotificationCenter) {
        view = LangPickerViewImpl()
        let model = LangPickerModelImpl(data: data, notificationCenter: notificationCenter)
        let viewModel = LangPickerViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        model.bindInitially()
    }

    var uiview: UIView? {
        view
    }
}

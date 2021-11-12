//
//  SearchTextInputMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchTextInputMVVMImpl: SearchTextInputMVVM {

    private let view: SearchTextInputViewImpl

    init() {
        view = SearchTextInputViewImpl()
        let model = SearchTextInputModelImpl()
        let viewModel = SearchTextInputViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var uiview: UIView? {
        view
    }
}

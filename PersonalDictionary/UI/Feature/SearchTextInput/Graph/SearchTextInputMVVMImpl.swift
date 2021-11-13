//
//  SearchTextInputMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchTextInputMVVMImpl: SearchTextInputMVVM {

    private let view: SearchTextInputViewImpl
    weak var model: SearchTextInputModel?

    init(viewParams: SearchTextInputViewParams,
         listener: SearchTextInputListener) {
        view = SearchTextInputViewImpl(params: viewParams)
        let model = SearchTextInputModelImpl(listener: listener)
        let viewModel = SearchTextInputViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        self.model = model
    }

    var uiview: UIView {
        view.uiview
    }
}

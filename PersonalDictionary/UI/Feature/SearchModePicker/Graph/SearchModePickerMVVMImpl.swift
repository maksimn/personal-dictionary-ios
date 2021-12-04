//
//  SearchModeMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

final class SearchModePickerMVVMImpl: SearchModePickerMVVM {

    private let view: SearchModePickerViewImpl

    weak var model: SearchModePickerModel?

    init(searchMode: SearchMode,
         viewParams: SearchModePickerViewParams) {
        view = SearchModePickerViewImpl(params: viewParams)
        let model = SearchModePickerModelImpl(searchMode: searchMode)
        let viewModel = SearchModePickerViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        model.bindInitially()
        self.model = model
    }

    var uiview: UIView {
        view
    }

}

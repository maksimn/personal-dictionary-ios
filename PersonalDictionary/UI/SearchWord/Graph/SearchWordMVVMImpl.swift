//
//  SearchWordMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class SearchWordMVVMImpl: SearchWordMVVM {

    private let view: SearchWordViewController

    init() {
        view = SearchWordViewController()
        let model = SearchWordModelImpl()
        let viewModel = SearchWordViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
    }

    var viewController: UIViewController? {
        view
    }
}

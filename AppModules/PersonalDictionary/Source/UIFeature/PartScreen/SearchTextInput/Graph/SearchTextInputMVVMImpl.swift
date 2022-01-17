//
//  SearchTextInputMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Реализация MVVM-графа фичи "Элемент ввода поискового текста".
final class SearchTextInputMVVMImpl: SearchTextInputMVVM {

    private let view: SearchTextInputViewImpl

    /// Модель фичи.
    private(set) weak var model: SearchTextInputModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления.
    init(viewParams: SearchTextInputViewParams) {
        view = SearchTextInputViewImpl(params: viewParams)
        let model = SearchTextInputModelImpl()
        let viewModel = SearchTextInputViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        self.model = model
    }

    /// Представление фичи.
    var uiview: UIView {
        view.uiview
    }
}

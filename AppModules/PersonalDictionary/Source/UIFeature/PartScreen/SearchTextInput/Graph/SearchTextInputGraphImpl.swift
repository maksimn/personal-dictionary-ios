//
//  SearchTextInputMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Реализация графа фичи "Элемент ввода поискового текста".
final class SearchTextInputGraphImpl: SearchTextInputGraph {

    private let view: SearchTextInputView

    /// Модель фичи.
    private(set) weak var model: SearchTextInputModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления.
    init(viewParams: SearchTextInputViewParams) {
        let model = SearchTextInputModelImpl()
        let viewModel = SearchTextInputViewModelImpl(model: model)
        view = SearchTextInputView(params: viewParams, viewModel: viewModel)

        model.viewModel = viewModel
        
        self.model = model
    }

    /// Представление фичи.
    var uiview: UIView {
        view.uiview
    }
}

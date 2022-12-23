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
    private(set) weak var viewModel: SearchTextInputViewModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления.
    init(viewParams: SearchTextInputViewParams) {
        let viewModel = SearchTextInputViewModelImpl()
        view = SearchTextInputView(params: viewParams, viewModel: viewModel)
        
        self.viewModel = viewModel
    }

    /// Представление фичи.
    var uiview: UIView {
        view.uiview
    }
}

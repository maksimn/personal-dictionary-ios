//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerGraphImpl: LangPickerGraph {

    /// Представление выбора языка
    private(set) var uiview: UIView

    /// Модель для выбора языка
    private(set) weak var model: LangPickerModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления выбора языка.
    init(viewParams: LangPickerParams) {
        weak var viewModelLazy: LangPickerViewModel?

        let model = LangPickerModelImpl(viewModelBlock: { viewModelLazy })
        let viewModel = LangPickerViewModelImpl(model: model)
        let view = LangPickerView(params: viewParams, viewModel: viewModel)

        viewModelLazy = viewModel

        uiview = view
        self.model = model
    }
}

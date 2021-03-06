//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

final class LangPickerMVVMImpl: LangPickerMVVM {

    /// Представление выбора языка
    private(set) var uiview: UIView?

    /// Модель для выбора языка
    weak var model: LangPickerModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления выбора языка.
    init(viewParams: LangPickerViewParams) {
        let model = LangPickerModelImpl()
        let viewModel = LangPickerViewModelImpl(model: model)
        let view = LangPickerViewImpl(params: viewParams, viewModel: viewModel)

        model.viewModel = viewModel

        uiview = view
        self.model = model
    }
}

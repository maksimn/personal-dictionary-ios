//
//  LangPickerMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import CoreModule
import UIKit

final class LangPickerGraphImpl: LangPickerGraph {

    /// Представление выбора языка
    let uiview: UIView

    /// Модель представления выбора языка
    let viewmodel: LangPickerViewModel

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления выбора языка.
    init(viewParams: LangPickerParams) {
        let viewmodel = LangPickerViewModelImpl()
        let view = LangPickerView(
            params: viewParams,
            viewModel: viewmodel,
            theme: Theme.data,
            logger: LoggerImpl(category: "PersonalDictionary.LangPicker")
        )

        uiview = view
        self.viewmodel = viewmodel
    }
}

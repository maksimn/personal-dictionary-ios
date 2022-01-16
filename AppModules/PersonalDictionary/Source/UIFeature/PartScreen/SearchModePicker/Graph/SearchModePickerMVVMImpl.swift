//
//  SearchModeMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

/// Реализация MVVM-графа фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerMVVMImpl: SearchModePickerMVVM {

    /// Представление выбора режима поиска.
    private(set) var uiview: UIView

    /// Модель выбора режима поиска.
    weak var model: SearchModePickerModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - searchMode: начальное значение режима поиска;
    ///  - viewParams: параметры представления.
    init(searchMode: SearchMode,
         viewParams: SearchModePickerViewParams) {
        let view = SearchModePickerViewImpl(params: viewParams)
        let model = SearchModePickerModelImpl(searchMode: searchMode)
        let viewModel = SearchModePickerViewModelImpl(model: model, view: view)

        view.viewModel = viewModel
        model.viewModel = viewModel
        model.bindInitially()

        self.model = model
        uiview = view
    }
}

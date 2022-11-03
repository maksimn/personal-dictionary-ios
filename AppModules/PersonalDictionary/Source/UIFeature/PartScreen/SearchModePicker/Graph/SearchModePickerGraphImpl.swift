//
//  SearchModeMVVMImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

/// Реализация MVVM-графа фичи "Выбор режима поиска" по словам из словаря.
final class SearchModePickerGraphImpl: SearchModePickerGraph {

    /// Представление выбора режима поиска.
    let uiview: UIView

    /// Модель выбора режима поиска.
    private(set) weak var model: SearchModePickerModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - searchMode: начальное значение режима поиска;
    ///  - viewParams: параметры представления.
    init(searchMode: SearchMode,
         viewParams: SearchModePickerViewParams) {
        let model = SearchModePickerModelImpl()
        let viewModel = SearchModePickerViewModelImpl(model: model, searchMode: searchMode)
        let view = SearchModePickerView(params: viewParams, viewModel: viewModel)

        model.viewModel = viewModel

        uiview = view
        self.model = model
    }
}

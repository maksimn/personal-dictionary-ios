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

    /// Модель представления выбора режима поиска.
    private(set) weak var viewModel: SearchModePickerViewModel?

    /// Инициализатор.
    /// - Parameters:
    ///  - searchMode: начальное значение режима поиска;
    ///  - viewParams: параметры представления.
    init(searchMode: SearchMode,
         viewParams: SearchModePickerViewParams) {
        let viewModel = SearchModePickerViewModelImpl(searchMode: searchMode)
        let view = SearchModePickerView(params: viewParams, viewModel: viewModel)

        uiview = view
        self.viewModel = viewModel
    }
}

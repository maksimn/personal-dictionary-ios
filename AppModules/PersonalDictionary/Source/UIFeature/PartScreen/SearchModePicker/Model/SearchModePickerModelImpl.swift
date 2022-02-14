//
//  SearchModeModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import CoreModule

/// Реализация модели выбора режима поиска.
final class SearchModePickerModelImpl: SearchModePickerModel {

    /// Модель представления выбора режима поиска.
    weak var viewModel: SearchModePickerViewModel?

    /// Делегат фичи "Выбор режима поиска".
    weak var listener: SearchModePickerListener?

    /// Режим поиска (стейт)
    private(set) var searchMode: SearchMode {
        didSet {
            viewModel?.setModelData()
        }
    }

    /// Инициализатор.
    /// - Parameters:
    ///  - searchMode: начальное значение режима поиска.
    init(searchMode: SearchMode) {
        self.searchMode = searchMode
    }

    /// Обновить режим поиска.
    /// - Parameters:
    ///  - searchMode: значение режима поиска.
    func update(_ searchMode: SearchMode) {
        self.searchMode = searchMode
        listener?.onSearchModeChanged(searchMode)
    }
}

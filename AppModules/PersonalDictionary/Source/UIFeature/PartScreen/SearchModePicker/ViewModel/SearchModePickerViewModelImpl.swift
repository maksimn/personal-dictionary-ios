//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxCocoa

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    private let model: SearchModePickerModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель фичи "Выбор режима поиска"
    init(model: SearchModePickerModel) {
        self.model = model
    }

    /// Режим поиска (данные модели представления).
    let searchMode = BehaviorRelay<SearchMode>(value: .bySourceWord)
}

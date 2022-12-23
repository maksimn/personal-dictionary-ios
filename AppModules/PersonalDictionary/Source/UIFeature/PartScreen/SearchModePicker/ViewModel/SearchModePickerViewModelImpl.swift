//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация модели представления выбора режима поиска.
final class SearchModePickerViewModelImpl: SearchModePickerViewModel {

    /// Режим поиска (данные модели представления).
    let searchMode: BindableSearchMode

    init(searchMode: SearchMode) {
        self.searchMode = BindableSearchMode(value: searchMode)
    }
}

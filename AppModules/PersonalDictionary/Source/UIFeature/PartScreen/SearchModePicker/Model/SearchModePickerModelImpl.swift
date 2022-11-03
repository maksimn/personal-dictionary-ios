//
//  SearchModeModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация модели выбора режима поиска.
final class SearchModePickerModelImpl: SearchModePickerModel {

    weak var viewModel: SearchModePickerViewModel?

    weak var listener: SearchModePickerListener?

    var searchMode: SearchMode {
        viewModel?.searchMode.value ?? .bySourceWord
    }
}

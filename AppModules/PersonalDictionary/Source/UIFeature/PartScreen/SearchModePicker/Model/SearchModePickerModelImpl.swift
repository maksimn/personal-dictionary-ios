//
//  SearchModeViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Реализация модели выбора режима поиска.
final class SearchModePickerModelImpl: SearchModePickerModel {

    private let searchModeStream: MutableSearchModeStream

    init(searchModeStream: MutableSearchModeStream) {
        self.searchModeStream = searchModeStream
    }

    func set(searchMode: SearchMode) {
        searchModeStream.send(searchMode)
    }
}

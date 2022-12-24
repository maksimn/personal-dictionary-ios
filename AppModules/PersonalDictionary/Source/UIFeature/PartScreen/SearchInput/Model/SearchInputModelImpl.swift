//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация модели представления элемента ввода поискового текста.
final class SearchInputModelImpl: SearchInputModel {

    weak var listener: SearchInputListener?

    func onSearchTextChanged(_ searchText: String) {

    }

    func onSearchModeChanged(_ searchMode: SearchMode) {
    
    }
}

//
//  SearchTextInputViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputModelImpl: SearchTextInputModel {

    private let searchTextStream: MutableSearchTextStream

    init(searchTextStream: MutableSearchTextStream) {
        self.searchTextStream = searchTextStream
    }

    func set(searchText: String) {
        searchTextStream.send(searchText)
    }
}

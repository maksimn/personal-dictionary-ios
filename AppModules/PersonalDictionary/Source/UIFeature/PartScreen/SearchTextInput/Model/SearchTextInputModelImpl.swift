//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputModelImpl: SearchTextInputModel {

    weak var viewModel: SearchTextInputViewModel?

    weak var listener: SearchTextInputListener?

    var searchText: String {
        viewModel?.searchText.value ?? ""
    }
}

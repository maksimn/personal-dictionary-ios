//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import Foundation

/// Реализация модели элемента ввода поискового текста.
final class SearchTextInputModelImpl: SearchTextInputModel {

    /// Модель представления элемента ввода поискового текста.
    weak var viewModel: SearchTextInputViewModel?

    /// Делегат фичи
    weak var listener: SearchTextInputListener?

    /// Поисковый текст
    private(set) var searchText: String = "" {
        didSet {
            viewModel?.searchText = searchText
        }
    }

    /// Обновить поисковый текст.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func update(_ searchText: String) {
        self.searchText = searchText
        listener?.onSearchTextChanged(searchText)
    }
}

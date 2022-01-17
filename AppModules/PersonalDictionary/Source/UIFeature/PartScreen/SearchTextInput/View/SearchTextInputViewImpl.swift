//
//  SearchTextInputViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Реализация представления элемента ввода поискового текста.
final class SearchTextInputViewImpl: NSObject, SearchTextInputView, UISearchBarDelegate {

    /// Модель представления элемента ввода поискового текста.
    var viewModel: SearchTextInputViewModel?

    private let searchBar = UISearchBar()

    private let params: SearchTextInputViewParams

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления.
    init(params: SearchTextInputViewParams) {
        self.params = params
        super.init()
        initSearchBar()
    }

    /// UIView элемента ввода поискового текста.
    var uiview: UIView {
        searchBar
    }

    /// Задать поисковый текст для представления.
    /// - Parameters:
    ///  - searchText: поисковый текст.
    func set(_ searchText: String) {
        searchBar.text = searchText
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            viewModel?.updateModel(searchText)
        }
    }

    // MARK: - private

    private func initSearchBar() {
        searchBar.frame = CGRect(origin: .zero, size: params.size)
        searchBar.placeholder = params.placeholder
        searchBar.delegate = self
    }
}

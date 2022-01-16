//
//  SearchTextInputViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchTextInputViewImpl: NSObject, SearchTextInputView, UISearchBarDelegate {

    var viewModel: SearchTextInputViewModel?

    private let searchBar = UISearchBar()

    private let params: SearchTextInputViewParams

    init(params: SearchTextInputViewParams) {
        self.params = params
        super.init()
        initSearchBar()
    }

    var uiview: UIView {
        searchBar
    }

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

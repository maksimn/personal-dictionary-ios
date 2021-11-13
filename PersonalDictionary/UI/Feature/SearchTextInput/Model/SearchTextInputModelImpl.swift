//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import Foundation

final class SearchTextInputModelImpl: SearchTextInputModel {

    var viewModel: SearchTextInputViewModel?

    private weak var listener: SearchTextInputListener?

    init(listener: SearchTextInputListener) {
        self.listener = listener
    }

    private(set) var searchText: String = "" {
        didSet {
            viewModel?.searchText = searchText
        }
    }

    func update(_ searchText: String) {
        self.searchText = searchText
        listener?.onSearchTextChange(searchText)
    }
}

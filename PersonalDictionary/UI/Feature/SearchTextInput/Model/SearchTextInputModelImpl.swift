//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchTextInputModelImpl: SearchTextInputModel {

    var viewModel: SearchTextInputViewModel?

    private var searchText: String = "" {
        didSet {
            viewModel?.searchText = searchText
        }
    }

    func update(_ searchText: String) {
        self.searchText = searchText
        print("model update searchtext: \(searchText)")
    }
}

//
//  SearchTextInputModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import Foundation

final class SearchTextInputModelImpl: SearchTextInputModel {

    var viewModel: SearchTextInputViewModel?

    private let notificationCenter: NotificationCenter
    private weak var listener: SearchTextInputListener?

    init(notificationCenter: NotificationCenter, listener: SearchTextInputListener) {
        self.notificationCenter = notificationCenter
        self.listener = listener
    }

    private var searchText: String = "" {
        didSet {
            viewModel?.searchText = searchText
        }
    }

    func update(_ searchText: String) {
        self.searchText = searchText
        listener?.onSearchTextChange(searchText)
    }
}

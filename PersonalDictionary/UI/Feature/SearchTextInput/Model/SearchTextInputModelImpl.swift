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

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    private var searchText: String = "" {
        didSet {
            viewModel?.searchText = searchText
        }
    }

    func update(_ searchText: String) {
        self.searchText = searchText
        notificationCenter.post(name: .searchTextChanged, object: nil,
                                userInfo: [Notification.Name.searchTextChanged: searchText])
    }
}

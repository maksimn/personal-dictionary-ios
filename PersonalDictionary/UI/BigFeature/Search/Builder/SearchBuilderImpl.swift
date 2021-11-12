//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func build() -> SearchGraph {
        SearchGraphImpl(searchTextInputBuilder: SearchTextInputBuilderImpl(notificationCenter: notificationCenter))
    }
}

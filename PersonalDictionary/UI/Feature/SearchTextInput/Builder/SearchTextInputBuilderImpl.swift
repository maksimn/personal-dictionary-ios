//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import Foundation

final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func build() -> SearchTextInputMVVM {
        SearchTextInputMVVMImpl(notificationCenter: notificationCenter)
    }
}

//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

    private let notificationCenter: NotificationCenter

    private let viewParams = SearchTextInputViewParams(
        staticContent: SearchTextInputStaticContent(
            placeholder: NSLocalizedString("Enter a word for searching", comment: "")
        ),
        styles: SearchTextInputStyles(size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44))
    )

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func build() -> SearchTextInputMVVM {
        SearchTextInputMVVMImpl(viewParams: viewParams, notificationCenter: notificationCenter)
    }
}

//
//  SearchTextInputDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class SearchTextInputDependencies {

    private(set) lazy var viewParams = {
        SearchTextInputViewParams(
            staticContent: SearchTextInputStaticContent(
                placeholder: Bundle(for: type(of: self)).moduleLocalizedString("Enter a word for searching")
            ),
            styles: SearchTextInputStyles(size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44))
        )
    }()
}

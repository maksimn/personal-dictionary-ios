//
//  SearchTextInputDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class SearchTextInputDependencies {

    private(set) lazy var viewParams = SearchTextInputViewParams(
        placeholder: Bundle(for: type(of: self)).moduleLocalizedString("Enter a word for searching"),
        size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44)
    )
}

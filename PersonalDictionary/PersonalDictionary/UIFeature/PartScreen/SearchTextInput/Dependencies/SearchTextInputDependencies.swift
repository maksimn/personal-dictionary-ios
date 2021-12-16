//
//  SearchTextInputDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class SearchTextInputDependencies {

    let viewParams = SearchTextInputViewParams(
        staticContent: SearchTextInputStaticContent(
            placeholder: NSLocalizedString("Enter a word for searching", comment: "")
        ),
        styles: SearchTextInputStyles(size: CGSize(width: UIScreen.main.bounds.width - 72, height: 44))
    )
}

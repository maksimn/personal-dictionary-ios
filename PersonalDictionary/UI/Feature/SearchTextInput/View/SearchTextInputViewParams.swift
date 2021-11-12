//
//  SearchTextInputViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

struct SearchTextInputStaticContent {
    let placeholder: String
}

struct SearchTextInputStyles {
    let size: CGSize
}

typealias SearchTextInputViewParams = ViewParams<SearchTextInputStaticContent, SearchTextInputStyles>

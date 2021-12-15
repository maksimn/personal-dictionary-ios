//
//  LangPickerPopupParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

struct LangPickerPopupStaticContent {
    let selectButtonTitle: String
    let langs: [Lang]
}

struct LangPickerPopupStyles {
    let backgroundColor: UIColor
}

typealias LangPickerPopupParams = ViewParams<LangPickerPopupStaticContent, LangPickerPopupStyles>

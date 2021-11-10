//
//  LangPickerViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

struct LangPickerViewStaticContent {
    let selectButtonTitle: String
}

struct LangPickerViewStyles {
    let backgroundColor: UIColor
}

typealias LangPickerViewParams = ViewParams<LangPickerViewStaticContent, LangPickerViewStyles>

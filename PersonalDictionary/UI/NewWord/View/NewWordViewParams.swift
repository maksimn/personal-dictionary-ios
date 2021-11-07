//
//  NewWordViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

struct NewWordViewStaticContent {
    let selectButtonTitle: String
    let arrowText: String
    let okText: String
    let textFieldPlaceholder: String
}

struct NewWordViewStyles {
    let backgroundColor: UIColor
}

typealias NewWordViewParams = ViewParams<NewWordViewStaticContent, NewWordViewStyles>

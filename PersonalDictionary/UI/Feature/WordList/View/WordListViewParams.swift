//
//  WordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

typealias WordListViewParams = ViewParams<WordListViewStaticContent, WordListViewStyles>

struct WordListViewStaticContent {
    let deleteAction: DeleteActionStaticContent
}

struct WordListViewStyles {
    let backgroundColor: UIColor
    let deleteAction: DeleteActionStyles
}

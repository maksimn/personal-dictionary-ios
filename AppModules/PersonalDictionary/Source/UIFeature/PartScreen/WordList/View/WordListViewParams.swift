//
//  WordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

typealias WordListViewParams = ViewParams<WordListViewStaticContent, WordListViewStyles>

struct WordListViewStaticContent {
    let tableViewParams: WordTableViewParams
}

struct WordListViewStyles {
    let backgroundColor: UIColor
    let itemHeight: CGFloat
    let cellClass: AnyClass
    let cellReuseIdentifier: String
    let cellCornerRadius: CGFloat
}

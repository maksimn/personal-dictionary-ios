//
//  WordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

struct WordListViewParams {
    let tableViewParams: WordTableViewParams
    let backgroundColor: UIColor
    let itemHeight: CGFloat
    let cellClass: AnyClass
    let cellReuseIdentifier: String
    let cellCornerRadius: CGFloat
}

//
//  MainWordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

struct MainWordListStaticContent {
    let navToNewWordImage: UIImage
}

struct MainWordListStyles {
    let navToNewWordButtonSize: CGSize
    let navToNewWordButtonBottomOffset: CGFloat
}

typealias MainWordListViewParams = ViewParams<MainWordListStaticContent, MainWordListStyles>

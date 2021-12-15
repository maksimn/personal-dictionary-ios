//
//  MainWordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

struct MainWordListStaticContent {
    let heading: String
    let navToNewWordImage: UIImage
    let superAppRoutingButtonTitle: String
    let visibleItemMaxCount: Int
}

struct MainWordListStyles {
    let backgroundColor: UIColor
    let navToNewWordButtonSize: CGSize
    let navToNewWordButtonBottomOffset: CGFloat
}

typealias MainWordListViewParams = ViewParams<MainWordListStaticContent, MainWordListStyles>

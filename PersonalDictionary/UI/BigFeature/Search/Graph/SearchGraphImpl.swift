//
//  SearchGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchGraphImpl: SearchGraph {

    let controller: SearchViewController

    init(searchTextInputBuilder: SearchTextInputBuilder) {
        controller = SearchViewController(searchTextInputBuilder)
    }

    var viewController: UIViewController? {
        controller
    }
}

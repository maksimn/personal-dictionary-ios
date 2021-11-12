//
//  SearchGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchGraphImpl: SearchGraph {

    private let controller: SearchViewController

    init(searchTextInputBuilder: SearchTextInputBuilder,
         searchEngineBuilder: SearchEngineBuilder) {
        controller = SearchViewController(searchTextInputBuilder, searchEngineBuilder)
    }

    var viewController: UIViewController? {
        controller
    }
}

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
         searchEngineBuilder: SearchEngineBuilder,
         wordListBuilder: WordListBuilder) {
        controller = SearchViewController(searchTextInputBuilder,
                                          searchEngineBuilder,
                                          wordListBuilder)
    }

    var viewController: UIViewController? {
        controller
    }
}

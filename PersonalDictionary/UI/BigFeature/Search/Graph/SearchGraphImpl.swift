//
//  SearchGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchGraphImpl: SearchGraph {

    private let searchViewController: SearchViewController

    init(searchTextInputBuilder: SearchTextInputBuilder,
         searchEngineBuilder: SearchEngineBuilder,
         wordListBuilder: WordListBuilder) {
        searchViewController = SearchViewController(searchTextInputBuilder,
                                                    searchEngineBuilder,
                                                    wordListBuilder)
    }

    var viewController: UIViewController? {
        searchViewController
    }
}

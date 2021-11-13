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
         wordListBuilder: WordListBuilder,
         textLabelBuilder: TextLabelBuilder) {
        searchViewController = SearchViewController(searchTextInputBuilder,
                                                    searchEngineBuilder,
                                                    wordListBuilder,
                                                    textLabelBuilder)
    }

    var viewController: UIViewController? {
        searchViewController
    }
}

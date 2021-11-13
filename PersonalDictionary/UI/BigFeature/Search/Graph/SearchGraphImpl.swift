//
//  SearchGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchGraphImpl: SearchGraph {

    private let searchViewController: SearchViewController

    init(appViewConfigs: AppViewConfigs,
         wordListRepository: WordListRepository,
         wordListBuilder: WordListBuilder,
         textLabelBuilder: TextLabelBuilder) {
        let searchTextInputBuilder = SearchTextInputBuilderImpl()
        let searchModePickerBuilder = SearchModePickerBuilderImpl()
        let searchEngineBuilder = SearchEngineBuilderImpl(wordListRepository: wordListRepository)

        searchViewController = SearchViewController(appViewConfigs,
                                                    searchTextInputBuilder,
                                                    searchEngineBuilder,
                                                    wordListBuilder,
                                                    textLabelBuilder,
                                                    searchModePickerBuilder)
    }

    var viewController: UIViewController? {
        searchViewController
    }
}

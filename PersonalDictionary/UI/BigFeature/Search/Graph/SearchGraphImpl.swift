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
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder,
         searchResultTextLabelParams: TextLabelParams) {
        let searchTextInputBuilder = SearchTextInputBuilderImpl()
        let searchModePickerBuilder = SearchModePickerBuilderImpl()
        let searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListFetcher)

        searchViewController = SearchViewController(appViewConfigs,
                                                    searchTextInputBuilder,
                                                    searchEngineBuilder,
                                                    wordListBuilder,
                                                    searchModePickerBuilder,
                                                    searchResultTextLabelParams)
    }

    var viewController: UIViewController? {
        searchViewController
    }
}

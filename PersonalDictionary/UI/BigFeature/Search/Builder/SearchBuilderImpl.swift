//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

final class SearchBuilderImpl: SearchBuilder {

    private let wordListFetcher: WordListFetcher
    private let wordListBuilder: WordListBuilder

    private let searchResultTextLabelParams = TextLabelParams(textColor: .darkGray,
                                                              font: UIFont.systemFont(ofSize: 17),
                                                              text: NSLocalizedString("No words found", comment: ""))
    private let appViewConfigs: AppViewConfigs

    private let searchTextInputBuilder = SearchTextInputBuilderImpl()
    private let searchModePickerBuilder = SearchModePickerBuilderImpl()
    private lazy var searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListFetcher)

    init(appViewConfigs: AppViewConfigs,
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder) {
        self.appViewConfigs = appViewConfigs
        self.wordListFetcher = wordListFetcher
        self.wordListBuilder = wordListBuilder
    }

    func build() -> UIViewController {
        SearchViewController(appViewConfigs: appViewConfigs,
                             searchTextInputBuilder: searchTextInputBuilder,
                             searchEngineBuilder: searchEngineBuilder,
                             wordListBuilder: wordListBuilder,
                             searchModePickerBuilder: searchModePickerBuilder,
                             searchResultTextLabelParams: searchResultTextLabelParams)
    }
}

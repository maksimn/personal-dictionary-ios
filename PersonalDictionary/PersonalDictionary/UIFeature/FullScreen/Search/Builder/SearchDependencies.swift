//
//  SearchDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class SearchDependencies {

    let appViewConfigs: AppViewConfigs
    let wordListBuilder: WordListBuilder

    let searchResultTextLabelParams = TextLabelParams(textColor: .darkGray,
                                                      font: UIFont.systemFont(ofSize: 17),
                                                      text: NSLocalizedString("No words found", comment: ""))

    let searchTextInputBuilder = SearchTextInputBuilderImpl()
    let searchModePickerBuilder = SearchModePickerBuilderImpl()
    private(set) lazy var searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListFetcher)

    private let wordListFetcher: WordListFetcher

    init(appViewConfigs: AppViewConfigs,
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder) {
        self.appViewConfigs = appViewConfigs
        self.wordListFetcher = wordListFetcher
        self.wordListBuilder = wordListBuilder
    }
}

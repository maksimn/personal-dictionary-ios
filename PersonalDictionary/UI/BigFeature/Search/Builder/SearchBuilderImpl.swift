//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

final class SearchBuilderImpl: SearchBuilder {

    private let wordListRepository: WordListRepository
    private let wordListBuilder: WordListBuilder

    private let searchTextLabelParams = TextLabelParams(textColor: .darkGray,
                                                        font: UIFont.systemFont(ofSize: 17),
                                                        text: NSLocalizedString("No words found", comment: ""))
    private let appViewConfigs: AppViewConfigs

    init(appViewConfigs: AppViewConfigs,
         wordListRepository: WordListRepository,
         wordListBuilder: WordListBuilder) {
        self.appViewConfigs = appViewConfigs
        self.wordListRepository = wordListRepository
        self.wordListBuilder = wordListBuilder
    }

    func build() -> SearchGraph {
        SearchGraphImpl(appViewConfigs: appViewConfigs,
                        wordListRepository: wordListRepository,
                        wordListBuilder: wordListBuilder,
                        textLabelBuilder: TextLabelBuilderImpl(params: searchTextLabelParams))
    }
}

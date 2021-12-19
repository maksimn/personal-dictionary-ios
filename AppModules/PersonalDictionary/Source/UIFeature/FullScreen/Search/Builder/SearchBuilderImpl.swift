//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

final class SearchBuilderImpl: SearchBuilder {

    private let dependencies: SearchDependencies

    init(appViewConfigs: AppViewConfigs,
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder) {
        dependencies = SearchDependencies(appViewConfigs: appViewConfigs,
                                          wordListFetcher: wordListFetcher,
                                          wordListBuilder: wordListBuilder)
    }

    func build() -> UIViewController {
        SearchViewController(appViewConfigs: dependencies.appViewConfigs,
                             searchTextInputBuilder: dependencies.searchTextInputBuilder,
                             searchEngineBuilder: dependencies.searchEngineBuilder,
                             wordListBuilder: dependencies.wordListBuilder,
                             searchModePickerBuilder: dependencies.searchModePickerBuilder,
                             searchResultTextLabelParams: dependencies.searchResultTextLabelParams)
    }
}

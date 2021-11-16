//
//  SearchGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchGraphImpl: SearchGraph {

    private let searchViewController: SearchViewController

    // ПЕРЕДЕЛАТЬ: вынести зависимости в билдер, и удалить сущность графа, так как здесь создается только один объект.
    init(appViewConfigs: AppViewConfigs,
         wordListFetcher: WordListFetcher,
         wordListBuilder: WordListBuilder,
         searchResultTextLabelParams: TextLabelParams) {
        let searchTextInputBuilder = SearchTextInputBuilderImpl()
        let searchModePickerBuilder = SearchModePickerBuilderImpl()
        let searchEngineBuilder = SearchEngineBuilderImpl(wordListFetcher: wordListFetcher)

        // ПЕРЕДЕЛАТЬ: Сделать лейблы для аргументов конструктора.
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

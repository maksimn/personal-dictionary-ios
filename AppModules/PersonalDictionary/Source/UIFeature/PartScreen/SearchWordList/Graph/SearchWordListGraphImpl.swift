//
//  WordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class SearchWordListGraphImpl: SearchWordListGraph {

    let viewController: UIViewController

    private(set) weak var model: SearchWordListModel?

    init(
        wordListBuilder: WordListBuilder,
        searchableWordList: SearchableWordList,
        noResultFoundText: String
    ) {
        weak var viewModelLazy: SearchWordListViewModel?

        let model = SearchWordListModelImpl(
            viewModelBlock: { viewModelLazy },
            searchEngine: SearchEngineImpl(searchableWordList: searchableWordList)
        )
        let viewModel = SearchWordListViewModelImpl(
            initialData: SearchResultData(searchState: .initial, foundWordList: []),
            model: model
        )
        let view = SearchWordListViewController(
            viewModel: viewModel,
            wordListBuilder: wordListBuilder,
            noResultFoundText: noResultFoundText
        )

        viewModelLazy = viewModel

        viewController = view
        self.model = model
    }
}

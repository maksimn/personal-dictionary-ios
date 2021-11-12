//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController, SearchTextInputListener {

    private var searchTextInputMVVM: SearchTextInputMVVM?
    private let searchEngine: SearchEngine
    private let wordListMVVM: WordListMVVM

    init(_ searchTextInputBuilder: SearchTextInputBuilder,
         _ searchEngineBuilder: SearchEngineBuilder,
         _ wordListBuilder: WordListBuilder) {
        searchEngine = searchEngineBuilder.build()
        wordListMVVM = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        searchTextInputMVVM = searchTextInputBuilder.build(self)
        navigationItem.titleView = searchTextInputMVVM?.uiview

        guard let wordListViewController = wordListMVVM.viewController else { return }
        add(child: wordListViewController)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onSearchTextChange(_ searchText: String) {
        searchEngine.findItems(contain: searchText, completion: { [weak self] foundWordItems in
            guard let wordListModel = self?.wordListMVVM.model else { return }

            wordListModel.data = WordListData(wordList: foundWordItems, changedItemPosition: nil)
        })
    }
}

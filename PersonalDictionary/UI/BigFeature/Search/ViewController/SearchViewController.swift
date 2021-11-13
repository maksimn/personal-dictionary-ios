//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController, SearchTextInputListener, SearchModePickerListener {

    let searchEngine: SearchEngine
    let wordListMVVM: WordListMVVM
    var searchTextInputMVVM: SearchTextInputMVVM?
    var searchResultTextLabel: TextLabel?
    var searchModePickerMVVM: SearchModePickerMVVM?

    init(_ appViewConfigs: AppViewConfigs,
         _ searchTextInputBuilder: SearchTextInputBuilder,
         _ searchEngineBuilder: SearchEngineBuilder,
         _ wordListBuilder: WordListBuilder,
         _ textLabelBuilder: TextLabelBuilder,
         _ searchModePickerBuilder: SearchModePickerBuilder) {
        searchEngine = searchEngineBuilder.build()
        wordListMVVM = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        addFeature(searchTextInputBuilder)
        addWordListViewController()
        addSearchResultTextLabel(textLabelBuilder)
        addFeature(searchModePickerBuilder)
        view.backgroundColor = appViewConfigs.appBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchTextInputListener

    func onSearchTextChange(_ searchText: String) {
        guard let searchMode = searchModePickerMVVM?.model?.searchMode else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - SearchModePickerListener

    func onSearchModeChanged(_ searchMode: SearchMode) {
        guard let searchText = searchTextInputMVVM?.model?.searchText else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - Private

    private func performSearch(for searchText: String, mode: SearchMode) {
        searchEngine.findItems(contain: searchText, mode: mode, completion: { [weak self] data in
            guard let wordListModel = self?.wordListMVVM.model else { return }

            self?.searchResultTextLabel?.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListModel.data = WordListData(wordList: data.foundWordList, changedItemPosition: nil)
        })
    }
}

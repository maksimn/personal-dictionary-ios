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
    private var searchResultTextLabel: TextLabel?

    init(_ searchTextInputBuilder: SearchTextInputBuilder,
         _ searchEngineBuilder: SearchEngineBuilder,
         _ wordListBuilder: WordListBuilder,
         _ textLabelBuilder: TextLabelBuilder) {
        searchEngine = searchEngineBuilder.build()
        wordListMVVM = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        addFeature(searchTextInputBuilder)
        addWordListViewController()
        addSearchResultTextLabel(textLabelBuilder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchTextInputListener

    func onSearchTextChange(_ searchText: String) {
        searchEngine.findItems(contain: searchText, completion: { [weak self] data in
            guard let wordListModel = self?.wordListMVVM.model else { return }

            self?.searchResultTextLabel?.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListModel.data = WordListData(wordList: data.foundWordList, changedItemPosition: nil)
        })
    }

    // MARK: - Private

    private func addFeature(_ searchTextInputBuilder: SearchTextInputBuilder) {
        searchTextInputMVVM = searchTextInputBuilder.build(self)
        navigationItem.titleView = searchTextInputMVVM?.uiview
    }

    private func addWordListViewController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }
        add(child: wordListViewController)
    }

    private func addSearchResultTextLabel(_ textLabelBuilder: TextLabelBuilder) {
        searchResultTextLabel = textLabelBuilder.build()
        searchResultTextLabel?.isHidden = true
        view.addSubview(searchResultTextLabel ?? UIView())
        searchResultTextLabel?.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}

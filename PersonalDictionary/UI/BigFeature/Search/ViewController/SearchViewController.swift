//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchViewController: UIViewController, SearchTextInputListener, SearchModePickerListener {

    private var searchTextInputMVVM: SearchTextInputMVVM?
    private let searchEngine: SearchEngine
    private let wordListMVVM: WordListMVVM
    private var searchResultTextLabel: TextLabel?
    private var searchModePickerMVVM: SearchModePickerMVVM?

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

    private func addFeature(_ searchTextInputBuilder: SearchTextInputBuilder) {
        searchTextInputMVVM = searchTextInputBuilder.build(self)
        navigationItem.titleView = searchTextInputMVVM?.uiview
    }

    private func addWordListViewController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }
        let wordListParentView = UIView()

        view.addSubview(wordListParentView)
        wordListParentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        let child = wordListViewController
        wordListParentView.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(wordListParentView)
        }
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

    private func addFeature(_ searchModePickerBuilder: SearchModePickerBuilder) {
        searchModePickerMVVM = searchModePickerBuilder.build(self)

        guard let searchModePickerView = searchModePickerMVVM?.uiview else { return }
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}

//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана поиска по словам в словаре.
final class SearchViewController: UIViewController, SearchTextInputListener, SearchModePickerListener {

    private let searchTextInputGraph: SearchTextInputGraph
    private let searchModePickerGraph: SearchModePickerGraph
    private let searchWordListGraph: SearchWordListGraph

    /// - Parameters:
    ///  - searchTextInputBuilder: билдер вложенной фичи "Элемент ввода текста для поиска"
    ///  - searchModePickerBuilder: билдер вложенной фичи "Выбор режима поиска".
    init(searchTextInputBuilder: SearchTextInputBuilder,
         searchModePickerBuilder: SearchModePickerBuilder,
         searchWordListBuilder: SearchWordListBuilder) {
        searchTextInputGraph = searchTextInputBuilder.build()
        searchModePickerGraph = searchModePickerBuilder.build()
        searchWordListGraph = searchWordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchTextInputListener

    func onSearchTextChanged(_ searchText: String) {
        guard let searchMode = searchModePickerGraph.model?.searchMode else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - SearchModePickerListener

    func onSearchModeChanged(_ searchMode: SearchMode) {
        guard let searchText = searchTextInputGraph.model?.searchText else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - Private

    private func performSearch(for searchText: String, mode: SearchMode) {
        searchWordListGraph.model?.performSearch(for: searchText, mode: mode)
    }

    // MARK: - View and Layout

    private func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        initSearchTextInput()
        initSearchModePicker()
        layout(wordListViewController: searchWordListGraph.viewController, topOffset: 50)
    }

    private func initSearchTextInput() {
        searchTextInputGraph.model?.listener = self
        navigationItem.titleView = searchTextInputGraph.uiview
    }

    private func initSearchModePicker() {
        searchModePickerGraph.model?.listener = self

        let searchModePickerView = searchModePickerGraph.uiview
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}

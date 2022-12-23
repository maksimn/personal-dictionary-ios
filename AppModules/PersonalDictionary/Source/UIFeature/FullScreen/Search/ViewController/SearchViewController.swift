//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// View controller экрана поиска по словам в словаре.
final class SearchViewController: UIViewController {

    private let searchTextInputGraph: SearchTextInputGraph
    private let searchModePickerGraph: SearchModePickerGraph
    private let searchWordListGraph: SearchWordListGraph

    private let disposeBag = DisposeBag()

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

    // MARK: - Private

    private func onSearchTextChanged(_ searchText: String) {
        guard let searchMode = searchModePickerGraph.viewModel?.searchMode.value else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    private func onSearchModeChanged(_ searchMode: SearchMode) {
        guard let searchText = searchTextInputGraph.viewModel?.searchText.value else { return }
        performSearch(for: searchText, mode: searchMode)
    }

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
        navigationItem.titleView = searchTextInputGraph.uiview
        searchTextInputGraph.viewModel?.searchText.subscribe(onNext: { [weak self] text in
            self?.onSearchTextChanged(text)
        }).disposed(by: disposeBag)
    }

    private func initSearchModePicker() {
        searchModePickerGraph.viewModel?.searchMode.subscribe(onNext: { [weak self] searchMode in
            self?.onSearchModeChanged(searchMode)
        }).disposed(by: disposeBag)

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

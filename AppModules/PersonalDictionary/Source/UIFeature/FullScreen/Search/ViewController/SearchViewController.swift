//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// View controller экрана поиска по словам в словаре.
final class SearchViewController: UIViewController, SearchTextInputListener, SearchModePickerListener {

    let noResultFoundText: String
    let searchTextInputMVVM: SearchTextInputMVVM
    let searchModePickerMVVM: SearchModePickerMVVM
    let wordListMVVM: WordListMVVM
    let searchEngine: SearchEngine

    let centerLabel = UILabel()

    private let disposeBag = DisposeBag()

    /// - Parameters:
    ///  - noResultFoundText: текст "ничего не найдено" в результате поиска.
    ///  - searchTextInputBuilder: билдер вложенной фичи "Элемент ввода текста для поиска"
    ///  - searchModePickerBuilder: билдер вложенной фичи "Выбор режима поиска"
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - searchEngineBuilder: билдер вложенной фичи "Поисковый Движок"
    init(noResultFoundText: String,
         searchTextInputBuilder: SearchTextInputBuilder,
         searchModePickerBuilder: SearchModePickerBuilder,
         wordListBuilder: WordListBuilder,
         searchEngineBuilder: SearchEngineBuilder) {
        self.noResultFoundText = noResultFoundText
        searchTextInputMVVM = searchTextInputBuilder.build()
        searchModePickerMVVM = searchModePickerBuilder.build()
        wordListMVVM = wordListBuilder.build()
        searchEngine = searchEngineBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchTextInputListener

    func onSearchTextChanged(_ searchText: String) {
        guard let searchMode = searchModePickerMVVM.model?.searchMode else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - SearchModePickerListener

    func onSearchModeChanged(_ searchMode: SearchMode) {
        guard let searchText = searchTextInputMVVM.model?.searchText else { return }
        performSearch(for: searchText, mode: searchMode)
    }

    // MARK: - Private

    private func performSearch(for searchText: String, mode: SearchMode) {
        searchEngine.findWords(contain: searchText, mode: mode)
            .subscribe(
                onSuccess: { [weak self] in
                    self?.showSearchResult(data: $0)
                }
            )
            .disposed(by: disposeBag)
    }

    private func showSearchResult(data: SearchResultData) {
        guard let wordListModel = self.wordListMVVM.model else { return }

        centerLabel.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
        wordListModel.wordList = data.foundWordList
    }
}

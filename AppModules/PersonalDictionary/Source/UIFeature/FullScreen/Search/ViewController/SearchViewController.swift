//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// Параметры представления поиска.
struct SearchViewParams {

    /// Параметры текстового сообщения о пустом результате поиска.
    let searchResultTextParams: TextLabelParams
}

/// View controller экрана поиска по словам в словаре.
final class SearchViewController: UIViewController, SearchTextInputListener, SearchModePickerListener {

    let searchEngine: SearchEngine
    let wordListMVVM: WordListMVVM
    var searchTextInputMVVM: SearchTextInputMVVM?
    var searchResultTextLabel: TextLabel?
    var searchModePickerMVVM: SearchModePickerMVVM?

    /// Инициализатор.
    /// - Parameters:
    ///  - searchViewParams: параметры представления поиска.
    ///  - searchTextInputBuilder: билдер вложенной фичи "Элемент ввода текста для поиска"
    ///  - searchModePickerBuilder: билдер вложенной фичи "Выбор режима поиска"
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - searchEngineBuilder: билдер вложенной фичи "Поисковый Движок"
    init(viewParams: SearchViewParams,
         searchTextInputBuilder: SearchTextInputBuilder,
         searchModePickerBuilder: SearchModePickerBuilder,
         wordListBuilder: WordListBuilder,
         searchEngineBuilder: SearchEngineBuilder) {
        searchEngine = searchEngineBuilder.build()
        wordListMVVM = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        addFeature(searchTextInputBuilder)
        addWordListViewController()
        addSearchResultTextLabel(viewParams.searchResultTextParams)
        addFeature(searchModePickerBuilder)
        view.backgroundColor = Theme.standard.backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchTextInputListener

    func onSearchTextChanged(_ searchText: String) {
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
        searchEngine.findWords(contain: searchText, mode: mode)
            .subscribe(
                onSuccess: { self.showSearchResult(data: $0) },
                onError: nil
            )
            .disposed(by: disposeBag)
    }

    private func showSearchResult(data: SearchResultData) {
        guard let wordListModel = self.wordListMVVM.model else { return }

        searchResultTextLabel?.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
        wordListModel.wordList = data.foundWordList
    }

    private let disposeBag = DisposeBag()
}

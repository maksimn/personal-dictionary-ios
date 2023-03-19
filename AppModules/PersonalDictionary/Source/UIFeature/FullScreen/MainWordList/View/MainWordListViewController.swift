//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import RxSwift
import UIKit

/// View controller Главного списка слов.
final class MainWordListViewController: UIViewController {

    private let viewModel: MainWordListViewModel
    private let wordListGraph: WordListGraph
    private let mainNavigator: MainNavigator
    private let searchController: UISearchController
    private let theme: Theme

    private let disposeBag = DisposeBag()

    /// - Parameters:
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    init(
        title: String,
        viewModel: MainWordListViewModel,
        wordListBuilder: WordListBuilder,
        mainNavigatorBuilder: MainNavigatorBuilder,
        searchTextInputBuilder: SearchControllerBuilder,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        self.searchController = searchTextInputBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
        layout(wordListView: wordListGraph.view)
        mainNavigator.appendTo(rootView: view)
        bindToViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.searchController = searchController
    }

    private func bindToViewModel() {
        viewModel.wordList.subscribe(onNext: { [weak self] wordList in
            guard let wordListViewModel = self?.wordListGraph.viewModel else { return }

            wordListViewModel.wordList.accept(wordList)
        }).disposed(by: disposeBag)
    }
}

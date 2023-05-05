//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// View controller Главного списка слов.
final class MainWordListViewController: UIViewController, MainWordListView {

    private let presenter: MainWordListPresenter
    private let wordListGraph: WordListGraph

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    init(
        presenter: MainWordListPresenter,
        wordListBuilder: WordListBuilder
    ) {
        self.presenter = presenter
        self.wordListGraph = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        layout(wordListView: wordListGraph.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchWordList()
    }

    func set(wordList: WordListState) {
        let wordListViewModel = wordListGraph.viewModel

        wordListViewModel.wordList.accept(wordList)
    }
}

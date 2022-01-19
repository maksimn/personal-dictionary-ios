//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Реализация представления списка слов.
final class WordListViewController: UIViewController, WordListView {

    private let viewModelBlock: () -> WordListViewModel?
    private lazy var viewModel: WordListViewModel? = viewModelBlock()

    let params: WordListViewParams

    let tableView = UITableView()

    lazy var tableDataSource = WordTableDataSource(
        tableView: tableView,
        data: WordListData(wordList: [], changedItemPosition: nil),
        cellReuseIdentifier: params.cellReuseIdentifier
    )

    lazy var tableActions = WordTableDelegate(
        params: params.delegateParams,
        onScrollFinish: { [weak self] in
            self?.onTableViewScrollFinish()
        },
        onDeleteTap: { [weak self] position in
            self?.onDeleteWordTap(position)
        }
    )

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModelBlock: замыкание для инициализации ссылки на модель представления.
    ///  - params: параметры представления.
    init(viewModelBlock: @escaping () -> WordListViewModel?,
         params: WordListViewParams) {
        self.viewModelBlock = viewModelBlock
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    /// Задать данные для показа в представлении.
    /// - Parameters:
    ///  - wordListData: данные о списке слов.
    func set(_ wordListData: WordListData) {
        tableDataSource.data = wordListData
    }

    // MARK: - User Action Handlers

    private func onDeleteWordTap(_ position: Int) {
        let item = tableDataSource.data.wordList[position]

        viewModel?.remove(at: position)
        viewModel?.sendRemovedWordItem(item)
    }

    private func onTableViewScrollFinish() {
        guard let indexPaths = tableView.indexPathsForVisibleRows,
              let start = indexPaths.first?.row,
              let end = indexPaths.last?.row else { return }

        viewModel?.requestTranslationsIfNeededWithin(startPosition: start, endPosition: end + 1)
    }
}

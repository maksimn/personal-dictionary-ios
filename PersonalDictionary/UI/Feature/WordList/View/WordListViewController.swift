//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

final class WordListViewController: UIViewController, WordListView {

    var viewModel: WordListViewModel?

    let params: WordListViewParams

    let tableView = UITableView()

    lazy var tableDataSource: WordTableDataSource = {
        WordTableDataSource(tableView: tableView, data: WordListData(wordList: [], changedItemPosition: nil))
    }()

    lazy var tableActions: WordTableDelegate = {
        WordTableDelegate(
            onScrollFinish: { [weak self] in
                self?.onTableViewScrollFinish()
            },
            onDeleteTap: { [weak self] position in
                self?.onDeleteWordTap(position)
            },
            deleteActionViewParams: DeleteActionViewParams(
                staticContent: params.staticContent.deleteAction,
                styles: params.styles.deleteAction
            )
        )
    }()

    init(params: WordListViewParams) {
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

    // MARK: - WordListView

    func set(_ wordListData: WordListData) {
        tableDataSource.data = wordListData
    }

    // MARK: - User Action Handlers

    private func onDeleteWordTap(_ position: Int) {
        let item = tableDataSource.data.wordList[position]

        viewModel?.remove(item, at: position)
    }

    private func onTableViewScrollFinish() {
        guard let indexPaths = tableView.indexPathsForVisibleRows,
              let start = indexPaths.first?.row,
              let end = indexPaths.last?.row else { return }

        viewModel?.requestTranslationsIfNeededWithin(startPosition: start, endPosition: end + 1)
    }
}

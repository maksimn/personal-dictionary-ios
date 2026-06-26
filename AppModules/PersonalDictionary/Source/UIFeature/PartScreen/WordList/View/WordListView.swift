//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import UIKit

/// Parameters of the word list view.
struct WordListViewParams {

    /// Height of the list (table) item
    let itemHeight: CGFloat

    /// Table cell class
    let cellClass: AnyClass

    /// Table cell reuse identifier
    let cellReuseIdentifier: String

    /// Table cell corner radius
    let cellCornerRadius: CGFloat

    /// Table delegate parameters
    let delegateParams: WordTableViewDelegateParams
}

/// Implementation of the word list view.
final class WordListView: UIView, ObservationLoopLegacy {

    private let viewModel: WordListViewModel
    private let params: WordListViewParams
    private let theme: Theme
    private let logger: Logger

    private let tableView = UITableView()

    private lazy var datasource = UITableViewDiffableDataSource<Int, Word>(
        tableView: tableView) { [weak self] tableView, indexPath, word in
        guard let params = self?.params, let theme = self?.theme,
            let cell = tableView.dequeueReusableCell(withIdentifier: params.cellReuseIdentifier,
                                                     for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }

        cell.set(word: word, theme)

        return cell
    }

    private lazy var tableActions = WordTableViewDelegate(
        params: params.delegateParams,
        onDeleteTap: { [weak self] position in
            self?.onDeleteWordTap(position)
        },
        onFavoriteTap: { [weak self] position in
            self?.onFavoriteTap(position)
        },
        onSelectItemTap: { [weak self] position in
            self?.onSelectItemTap(position)
        }
    )

    /// - Parameters:
    ///  - viewModel: модель представления.
    ///  - params: параметры представления.
    init(viewModel: WordListViewModel,
         params: WordListViewParams,
         theme: Theme,
         logger: Logger) {
        self.viewModel = viewModel
        self.params = params
        self.theme = theme
        self.logger = logger
        super.init(frame: .zero)
        initViews()
        startObservationLoop { [weak self] in
            guard let self = self else { return }
            let wordList = viewModel.wordList
            var snapshot = NSDiffableDataSourceSnapshot<Int, Word>()

            snapshot.appendSections([0])
            snapshot.appendItems(wordList, toSection: 0)

            self.datasource.apply(snapshot)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - User Action Handlers

    private func onDeleteWordTap(_ position: Int) {
        logTapOnTableViewCellDeleteButton(position)
        viewModel.remove(at: position)
    }

    private func onFavoriteTap(_ position: Int) {
        logTapOnTableViewCellStarButton(position)
        viewModel.toggleWordIsFavorite(at: position)
    }

    private func onSelectItemTap(_ position: Int) {
        viewModel.select(at: position)
    }

    // MARK: - Logging

    private func logTapOnTableViewCellDeleteButton(_ position: Int) {
        logger.debug("User tap on the word table view cell delete button, the cell: #\(position)")
    }

    private func logTapOnTableViewCellStarButton(_ position: Int) {
        logger.debug("User tap on the word table view cell star button, the cell: #\(position)")
    }

    // MARK: - Layout

    private func initViews() {
        backgroundColor = theme.backgroundColor
        addSubview(tableView)
        tableView.backgroundColor = theme.backgroundColor
        tableView.layer.cornerRadius = params.cellCornerRadius
        tableView.rowHeight = params.itemHeight
        tableView.register(params.cellClass, forCellReuseIdentifier: params.cellReuseIdentifier)
        tableView.dataSource = datasource
        tableView.delegate = tableActions
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12))
        }
        tableView.keyboardDismissMode = .onDrag
    }
}

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

    lazy var datasource = UITableViewDiffableDataSource<Int, WordItem>(tableView: tableView) {
        tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.params.cellReuseIdentifier,
                                                       for: indexPath) as? WordItemCell else {
            return UITableViewCell()
        }

        cell.set(wordItem: item)

        return cell
    }

    lazy var tableActions = WordTableDelegate(
        params: params.delegateParams,
        onScrollFinish: { [weak self] in
            self?.onTableViewScrollFinish()
        },
        onDeleteTap: { [weak self] position in
            self?.onDeleteWordTap(position)
        },
        onFavoriteTap: { [weak self] position in
            self?.onFavoriteTap(position)
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
    ///  - wordList: данные о списке слов.
    func set(_ wordList: [WordItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, WordItem>()

        snapshot.appendSections([0])
        snapshot.appendItems(wordList, toSection: 0)

        datasource.apply(snapshot)
    }

    // MARK: - User Action Handlers

    private func onDeleteWordTap(_ position: Int) {
        viewModel?.remove(at: position)
    }

    private func onFavoriteTap(_ position: Int) {
        viewModel?.toggleWordItemIsFavorite(at: position)
    }

    private func onTableViewScrollFinish() {
        guard let indexPaths = tableView.indexPathsForVisibleRows,
              let start = indexPaths.first?.row,
              let end = indexPaths.last?.row else { return }

        viewModel?.requestTranslationsIfNeededWithin(startPosition: start, endPosition: end + 1)
    }
}

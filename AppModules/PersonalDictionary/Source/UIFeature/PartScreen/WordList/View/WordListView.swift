//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit
import RxSwift

/// Параметры представления списка слов.
struct WordListViewParams {

    /// Высота элемента списка (таблицы)
    let itemHeight: CGFloat

    /// Класс ячейки таблицы
    let cellClass: AnyClass

    /// Reuse Id ячейки таблицы
    let cellReuseIdentifier: String

    /// Радиус скругления углов ячейки таблицы
    let cellCornerRadius: CGFloat

    /// Параметры делегата таблицы
    let delegateParams: WordTableViewDelegateParams
}

/// Реализация представления списка слов.
final class WordListView: UIView {

    private let viewModel: WordListViewModel

    private let params: WordListViewParams
    private let theme: Theme

    private let tableView = UITableView()

    private lazy var datasource = UITableViewDiffableDataSource<Int, Word>(tableView: tableView) {
        tableView, indexPath, word in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.params.cellReuseIdentifier,
                                                       for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }

        cell.set(word: word, self.theme)

        return cell
    }

    private lazy var tableActions = WordTableViewDelegate(
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

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - viewModel: модель представления.
    ///  - params: параметры представления.
    init(viewModel: WordListViewModel,
         params: WordListViewParams,
         theme: Theme) {
        self.viewModel = viewModel
        self.params = params
        self.theme = theme
        super.init(frame: .zero)
        initViews()
        bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindToViewModel() {
        viewModel.wordList
            .subscribe(onNext: { [weak self] wordList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Word>()

                snapshot.appendSections([0])
                snapshot.appendItems(wordList, toSection: 0)

                self?.datasource.apply(snapshot)
            }).disposed(by: disposeBag)
    }

    // MARK: - User Action Handlers

    private func onDeleteWordTap(_ position: Int) {
        viewModel.remove(at: position)
    }

    private func onFavoriteTap(_ position: Int) {
        viewModel.toggleWordIsFavorite(at: position)
    }

    private func onTableViewScrollFinish() {
        guard let indexPaths = tableView.indexPathsForVisibleRows,
              let start = indexPaths.first?.row,
              let end = indexPaths.last?.row else { return }

        viewModel.fetchTranslationsIfNeededWithin(start: start, end: end + 1)
            .subscribe().disposed(by: disposeBag)
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
        tableView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 14, left: 12, bottom: 0, right: 12))
        }
        tableView.keyboardDismissMode = .onDrag
    }
}

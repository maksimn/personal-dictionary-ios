//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit
import RxSwift

/// Реализация представления списка слов.
final class WordListViewController: UIViewController {

    private let viewModel: WordListViewModel

    let params: WordListViewParams
    let theme: Theme

    let tableView = UITableView()

    lazy var datasource = UITableViewDiffableDataSource<Int, Word>(tableView: tableView) {
        tableView, indexPath, word in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.params.cellReuseIdentifier,
                                                       for: indexPath) as? WordTableViewCell else {
            return UITableViewCell()
        }

        cell.set(word: word, self.theme)

        return cell
    }

    lazy var tableActions = WordTableViewDelegate(
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
        super.init(nibName: nil, bundle: nil)
        initViews()
        subscribeToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func subscribeToViewModel() {
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

        viewModel.requestTranslationsIfNeededWithin(startPosition: start, endPosition: end + 1)
    }
}

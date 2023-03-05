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

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    init(
        viewModel: MainWordListViewModel,
        wordListBuilder: WordListBuilder
    ) {
        self.viewModel = viewModel
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
        bindToViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
    }

    private func bindToViewModel() {
        viewModel.wordList.subscribe(onNext: { [weak self] wordList in
            guard let wordListViewModel = self?.wordListGraph.viewModel else { return }

            wordListViewModel.wordList.accept(wordList)
        }).disposed(by: disposeBag)
    }
}

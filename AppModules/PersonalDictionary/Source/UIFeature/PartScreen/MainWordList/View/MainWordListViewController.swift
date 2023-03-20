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
    private let navToNewWordView: UIView

    private let disposeBag = DisposeBag()

    init(
        viewModel: MainWordListViewModel,
        wordListBuilder: WordListBuilder,
        navToNewWordBuilder: NavToNewWordBuilder
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.navToNewWordView = navToNewWordBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        layout(wordListView: wordListGraph.view)
        addNavToNewWord()
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

    private func addNavToNewWord() {
        view.addSubview(navToNewWordView)
        navToNewWordView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }
}

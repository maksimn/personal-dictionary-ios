//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

final class SearchWordListViewController: UIViewController {

    private let viewModel: SearchWordListViewModel

    private let wordListGraph: WordListGraph

    private let centerLabel: UILabel

    private let disposeBag = DisposeBag()

    /// - Parameters:
    ///  - viewModel: модель представления.
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - labelText: текст для результата поиска.
    init(
        viewModel: SearchWordListViewModel,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.centerLabel = SecondaryText(labelText, theme)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
        bindToViewModel()
    }

    // MARK: - Private

    private func bindToViewModel() {
        viewModel.searchResult.subscribe(onNext: { [weak self] data in
            guard let wordListViewModel = self?.wordListGraph.viewModel else { return }

            self?.centerLabel.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListViewModel.wordList.accept(data.foundWordList)
        }).disposed(by: disposeBag)
    }

    // MARK: - Layout

    private func initViews() {
        layout(wordListView: wordListGraph.view)
        initCenterLabel()
    }

    private func initCenterLabel() {
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}

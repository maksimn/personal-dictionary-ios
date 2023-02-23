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
    ///  - noResultFoundText: текст "ничего не найдено" в результате поиска.
    init(
        viewModel: SearchWordListViewModel,
        wordListBuilder: WordListBuilder,
        noResultFoundText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        centerLabel = SecondaryText(noResultFoundText, theme)
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
            guard let wordListModel = self?.wordListGraph.model else { return }

            self?.centerLabel.isHidden = !(data.searchState == .fulfilled && data.foundWordList.count == 0)
            wordListModel.wordList = data.foundWordList
        }).disposed(by: disposeBag)
    }

    // MARK: - Layout

    private func initViews() {
        layout(wordListViewController: wordListGraph.viewController)
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

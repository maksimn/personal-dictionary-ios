//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

/// Реализация представления списка избранных слов.
final class FavoriteWordListViewController: UIViewController {

    private let viewModel: FavoriteWordListViewModel

    private let wordListGraph: WordListGraph

    private let centerLabel: UILabel

    private let disposeBag = DisposeBag()

    init(
        viewModel: FavoriteWordListViewModel,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        centerLabel = SecondaryText(labelText, theme)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchFavoriteWordList()
    }

    private func bindToViewModel() {
        viewModel.favoriteWordList.subscribe(onNext: { [weak self] wordList in
            self?.wordListGraph.viewModel.wordList.accept(wordList)
            self?.centerLabel.isHidden = !wordList.isEmpty
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

//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

/// Реализация представления списка избранных слов.
final class FavoritesViewController: UIViewController {

    private let viewModel: FavoritesViewModel

    private let wordListGraph: WordListGraph

    private let theme: Theme

    private let centerLabel: UILabel

    private let disposeBag = DisposeBag()

    init(
        title: String,
        viewModel: FavoritesViewModel,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.centerLabel = SecondaryText(labelText, theme)
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
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

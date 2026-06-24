//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Combine
import UIKit

/// Implementation of the favorite word list view.
final class FavoriteWordListViewController: UIViewController {

    private let viewModel: FavoriteWordListViewModel

    private let wordListGraph: WordListGraph

    private let centerLabel: UILabel

    private var cancellables: Set<AnyCancellable> = []

    init(
        viewModel: FavoriteWordListViewModel,
        wordListBuilder: WordListBuilder,
        labelText: String,
        theme: Theme
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        centerLabel = secondaryText(labelText, theme)
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
        viewModel.favoriteWordList.sink { [weak self] wordList in
            self?.wordListGraph.viewModel.wordList.send(wordList)
            self?.centerLabel.isHidden = !wordList.isEmpty
        }.store(in: &cancellables)
    }

    // MARK: - Layout

    private func initViews() {
        layout(wordListView: wordListGraph.view)
        initCenterLabel()
    }

    private func initCenterLabel() {
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}

//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RxSwift
import UIKit

/// Реализация представления списка избранных слов.
final class FavoriteWordListView: UIViewController {

    private let viewModel: FavoriteWordListViewModel

    private let wordListGraph: WordListGraph

    private let noFavoriteWordsText: String

    private let centerLabel = UILabel()

    private let disposeBag = DisposeBag()

    init(
        viewModel: FavoriteWordListViewModel,
        wordListBuilder: WordListBuilder,
        noFavoriteWordsText: String
    ) {
        self.viewModel = viewModel
        self.wordListGraph = wordListBuilder.build()
        self.noFavoriteWordsText = noFavoriteWordsText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        initViews()
        subscribeToViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.update()
    }

    // MARK: - Private

    private func subscribeToViewModel() {
        viewModel.favoriteWordList.subscribe(onNext: { [weak self] wordList in
            self?.wordListGraph.model?.wordList = wordList
            self?.centerLabel.isHidden = !wordList.isEmpty
        }).disposed(by: disposeBag)
    }

    private func initViews() {
        addWordListChildController()
        initCenterLabel()
    }

    private func addWordListChildController() {
        let wordListViewController = wordListGraph.viewController

        view.addSubview(wordListViewController.view)
        addChild(wordListViewController)
        wordListViewController.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view)
        }
    }

    private func initCenterLabel() {
        centerLabel.textColor = Theme.data.secondaryTextColor
        centerLabel.font = Theme.data.normalFont
        centerLabel.numberOfLines = 1
        centerLabel.textAlignment = .center
        centerLabel.text = noFavoriteWordsText
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}

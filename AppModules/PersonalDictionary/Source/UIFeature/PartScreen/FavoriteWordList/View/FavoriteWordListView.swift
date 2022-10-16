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

    private let wordListMVVM: WordListMVVM

    private let disposeBag = DisposeBag()

    init(
        viewModel: FavoriteWordListViewModel,
        wordListBuilder: WordListBuilder
    ) {
        self.viewModel = viewModel
        self.wordListMVVM = wordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        addWordListChildController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToViewModel()
    }

    // MARK: - Private

    private func addWordListChildController() {
        let wordListViewController = wordListMVVM.viewController

        view.addSubview(wordListViewController.view)
        addChild(wordListViewController)
        wordListViewController.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view)
        }
    }

    private func subscribeToViewModel() {
        viewModel.favoriteWordList.subscribe(onNext: { [weak self] wordList in
            self?.wordListMVVM.model?.wordList = wordList
        }).disposed(by: disposeBag)
    }
}

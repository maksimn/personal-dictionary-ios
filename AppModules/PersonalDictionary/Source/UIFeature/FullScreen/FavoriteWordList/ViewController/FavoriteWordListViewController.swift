//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

struct FavoriteWordListViewParams {

    let heading: String

    let textLabelParams: TextLabelParams
}

/// View controller экрана.
final class FavoriteWordListViewController: UIViewController {

    let params: FavoriteWordListViewParams

    let navToSearchBuilder: NavToSearchBuilder

    let wordListMVVM: WordListMVVM

    let favoriteWordListFetcher: FavoriteWordListFetcher

    let wordItemStream: WordItemStream

    let headingLabel = UILabel()

    var textLabel: TextLabel?

    private let disposeBag = DisposeBag()

    init(params: FavoriteWordListViewParams,
         navToSearchBuilder: NavToSearchBuilder,
         wordListBuilder: WordListBuilder,
         favoriteWordListFetcher: FavoriteWordListFetcher,
         wordItemStream: WordItemStream) {
        self.params = params
        self.navToSearchBuilder = navToSearchBuilder
        self.wordListMVVM = wordListBuilder.build()
        self.favoriteWordListFetcher = favoriteWordListFetcher
        self.wordItemStream = wordItemStream
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        fetchData()
        subscribeToWordItemStream()
    }

    private func fetchData() {
        let wordList = favoriteWordListFetcher.favoriteWordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.wordList = wordList
        textLabel?.isHidden = !wordList.isEmpty
    }

    private func subscribeToWordItemStream() {
        wordItemStream.removedWordItem
            .subscribe(onNext: { [weak self] _ in self?.fetchData() })
            .disposed(by: disposeBag)
        wordItemStream.updatedWordItem
            .subscribe(onNext: { [weak self] _ in self?.fetchData() })
            .disposed(by: disposeBag)
    }
}

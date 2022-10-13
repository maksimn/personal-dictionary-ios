//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import RxSwift
import UIKit

/// Параметры представления списка избранных слов.
struct FavoriteWordListViewParams {

    /// Текст заголовка
    let heading: String

    /// Текст "нет избранных слов"
    let noFavoriteWordsText: String
}

/// View controller экрана списка избранных слов.
final class FavoriteWordListViewController: UIViewController {

    let params: FavoriteWordListViewParams

    let navToSearchBuilder: NavToSearchBuilder

    let wordListMVVM: WordListMVVM

    let favoriteWordListFetcher: FavoriteWordListFetcher

    let readableWordItemStream: ReadableWordItemStream

    let headingLabel = UILabel()

    let centerLabel = UILabel()

    private let disposeBag = DisposeBag()

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры представления списка избранных слов.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - favoriteWordListFetcher: получение списка избранных слов из хранилища.
    ///  - readableWordItemStream: поток событий со словами в приложении.
    init(params: FavoriteWordListViewParams,
         navToSearchBuilder: NavToSearchBuilder,
         wordListBuilder: WordListBuilder,
         favoriteWordListFetcher: FavoriteWordListFetcher,
         readableWordItemStream: ReadableWordItemStream) {
        self.params = params
        self.navToSearchBuilder = navToSearchBuilder
        self.wordListMVVM = wordListBuilder.build()
        self.favoriteWordListFetcher = favoriteWordListFetcher
        self.readableWordItemStream = readableWordItemStream
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        subscribeToWordItemStream()
    }

    private func fetchData() {
        let wordList = favoriteWordListFetcher.favoriteWordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.wordList = wordList
        centerLabel.isHidden = !wordList.isEmpty
    }

    private func subscribeToWordItemStream() {
        readableWordItemStream.removedWordItem
            .subscribe(onNext: { [weak self] _ in self?.fetchData() })
            .disposed(by: disposeBag)
        readableWordItemStream.updatedWordItem
            .subscribe(onNext: { [weak self] _ in self?.fetchData() })
            .disposed(by: disposeBag)
    }
}

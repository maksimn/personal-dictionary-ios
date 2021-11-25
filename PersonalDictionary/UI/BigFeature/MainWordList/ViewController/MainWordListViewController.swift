//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

class MainWordListViewController: UIViewController, NewWordListener {

    let params: MainWordListViewParams

    let wordListMVVM: WordListMVVM
    let wordListFetcher: WordListFetcher
    let router: MainWordListRouter
    let visibleItemMaxCount: Int

    lazy var navToSearchView = { NavToSearchView(onTap: { [weak self] in self?.navigateToSearch() }) }()

    let navToNewWordButton = UIButton()

    let wordItemStream: WordItemStream

    init(viewParams: MainWordListViewParams,
         wordListMVVM: WordListMVVM,
         wordListFetcher: WordListFetcher,
         router: MainWordListRouter,
         visibleItemMaxCount: Int,
         wordItemStream: WordItemStream) {
        self.params = viewParams
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
        self.router = router
        self.visibleItemMaxCount = visibleItemMaxCount
        self.wordItemStream = wordItemStream
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initWordListModel()
    }

    func navigateToSearch() {
        router.navigateToSearch()
    }

    @objc
    func navigateToNewWord() {
        router.navigateToNewWord(listener: self)
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0, endPosition: visibleItemMaxCount + 1)
    }

    func onNewWord(_ wordItem: WordItem) {
        wordItemStream.sendNewWord(wordItem)
    }
}

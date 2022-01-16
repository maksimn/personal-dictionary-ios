//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule
import UIKit

class MainWordListViewController: UIViewController {

    let params: MainWordListViewParams

    let wordListMVVM: WordListMVVM
    let wordListFetcher: WordListFetcher
    let router: MainWordListRouter
    let coreRouter: CoreRouter?

    lazy var navToSearchView = NavToSearchView(onTap: { [weak self] in self?.navigateToSearch() })

    let navToNewWordButton = UIButton()
    let routingButton = UIButton()
    let myDictionaryLabel = UILabel()

    init(viewParams: MainWordListViewParams,
         wordListMVVM: WordListMVVM,
         wordListFetcher: WordListFetcher,
         router: MainWordListRouter,
         coreRouter: CoreRouter?) {
        self.params = viewParams
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
        self.router = router
        self.coreRouter = coreRouter
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

    @objc
    func onRoutingButtonTap() {
        coreRouter?.navigate()
    }

    @objc
    func navigateToNewWord() {
        router.navigateToNewWord()
    }

    private func navigateToSearch() {
        router.navigateToSearch()
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0,
                                                        endPosition: params.visibleItemMaxCount + 1)
    }
}

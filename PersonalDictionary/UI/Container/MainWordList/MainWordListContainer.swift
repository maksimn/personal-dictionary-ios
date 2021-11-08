//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

class MainWordListContainer: UIViewController {

    let wordListMVVM: WordListMVVM
    let wordListFetcher: WordListFetcher
    let router: Router
    let visibleItemMaxCount: Int

    lazy var navToSearchView = {
        NavToSearchView(onTap: { [weak self] in
            self?.navigateToSearch()
        })
    }()

    let navToNewWordButton = UIButton()

    init(wordListMVVM: WordListMVVM,
         wordListFetcher: WordListFetcher,
         router: Router,
         visibleItemMaxCount: Int) {
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
        self.router = router
        self.visibleItemMaxCount = visibleItemMaxCount
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
        router.navigateToNewWord()
    }

    private func initWordListModel() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededWithin(startPosition: 0, endPosition: visibleItemMaxCount + 1)
    }
}

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

    lazy var navToSearchView = {
        NavToSearchView(onTap: { [weak self] in
            self?.navigateToSearch()
        })
    }()

    let navToNewWordButton = UIButton()

    init(wordListMVVM: WordListMVVM,
         wordListFetcher: WordListFetcher,
         router: Router) {
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setDataForWordListMVVM()
    }

    func navigateToSearch() {
        router.navigateToSearch()
    }

    @objc
    func navigateToNewWord() {
        router.navigateToNewWord()
    }

    private func setDataForWordListMVVM() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededForFirstItems()
    }
}

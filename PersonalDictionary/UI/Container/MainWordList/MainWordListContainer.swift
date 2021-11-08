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

    lazy var navToSearchView = {
        NavToSearchView(onTap: { [weak self] in
            self?.onNavigateToSearchTap()
        })
    }()
    let newWordButton = UIButton()

    init(wordListMVVM: WordListMVVM, wordListFetcher: WordListFetcher) {
        self.wordListMVVM = wordListMVVM
        self.wordListFetcher = wordListFetcher
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

    private func setDataForWordListMVVM() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededForFirstItems()
    }

    func onNavigateToSearchTap() {

    }

    @objc
    func onNewWordButtonTap() {

    }
}

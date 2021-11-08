//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

class MainWordListContainer: UIViewController {

    private let wordListMVVM: WordListMVVM
    private let wordListFetcher: WordListFetcher

    private lazy var navToSearchView = {
        NavToSearchView(onTap: { [weak self] in
            self?.onNavigateToSearchTap()
        })
    }()

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

        navigationItem.titleView = navToSearchView

        addWordListChildController()
        setDataForWordListMVVM()
    }

    private func addWordListChildController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }

        add(child: wordListViewController)
    }

    private func setDataForWordListMVVM() {
        let wordList = wordListFetcher.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
        wordListModel.requestTranslationsIfNeededForFirstItems()
    }

    private func onNavigateToSearchTap() {
        print("onNavigateToSearchTap")
    }
}

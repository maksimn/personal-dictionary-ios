//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

class MainWordListContainer: UIViewController {

    let wordListMVVM: WordListMVVM
    let wordListRepository: WordListRepository

    init(wordListMVVM: WordListMVVM, wordListRepository: WordListRepository) {
        self.wordListMVVM = wordListMVVM
        self.wordListRepository = wordListRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let wordList = wordListRepository.wordList
        guard let wordListModel = wordListMVVM.model else { return }

        addWordListChild()
        wordListModel.data = WordListData(wordList: wordList, changedItemPosition: nil)
    }

    func addWordListChild() {
        guard let wordListViewController = wordListMVVM.viewController else { return }

        add(child: wordListViewController)
    }
}

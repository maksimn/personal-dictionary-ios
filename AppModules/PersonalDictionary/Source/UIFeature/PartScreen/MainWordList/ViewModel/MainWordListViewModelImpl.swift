//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import CoreModule

final class MainWordListViewModelImpl: MainWordListViewModel {

    let wordList = BindableWordList(value: [])

    private let wordListFetcher: WordListFetcher
    private let logger: Logger

    init(wordListFetcher: WordListFetcher, logger: Logger) {
        self.wordListFetcher = wordListFetcher
        self.logger = logger
    }

    func fetch() {
        let wordList = wordListFetcher.wordList

        self.wordList.accept(wordList)

        logger.logState(actionName: "FETCH MAIN WORDLIST", wordList)
    }
}

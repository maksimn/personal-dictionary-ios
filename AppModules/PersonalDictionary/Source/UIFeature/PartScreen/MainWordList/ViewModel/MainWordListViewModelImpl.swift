//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

final class MainWordListViewModelImpl: MainWordListViewModel {

    let wordList = BindableWordList(value: [])

    private let wordListFetcher: WordListFetcher

    init(wordListFetcher: WordListFetcher) {
        self.wordListFetcher = wordListFetcher
    }

    func fetch() {
        let wordList = wordListFetcher.wordList

        self.wordList.accept(wordList)
    }
}

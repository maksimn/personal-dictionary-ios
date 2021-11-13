//
//  SearchEngineImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import Dispatch

final class SearchEngineImpl: SearchEngine {

    private let wordListRepository: WordListRepository

    init(wordListRepository: WordListRepository) {
        self.wordListRepository = wordListRepository
    }

    func findItems(contain string: String, completion: @escaping (SearchResultData) -> Void) {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if string == "" {
            completion(SearchResultData(searchState: .initial, foundWordList: []))
            return
        }

        let allWordList = wordListRepository.wordList

        DispatchQueue.global(qos: .default).async {
            let searchedWordList = allWordList.filter { item in
                    item.text
                    .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                    .contains(string)
            }

            DispatchQueue.main.async {
                completion(SearchResultData(searchState: .fulfilled, foundWordList: searchedWordList))
            }
        }
    }
}

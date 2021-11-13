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

    func findItems(contain string: String, mode: SearchMode, completion: @escaping (SearchResultData) -> Void) {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if string == "" {
            return completion(SearchResultData(searchState: .initial, foundWordList: []))
        }

        let allWordList = wordListRepository.wordList

        DispatchQueue.global(qos: .default).async {
            let filteredWordList = allWordList.filter { item in
                (mode == .bySourceWord ? item.text : (item.translation ?? ""))
                    .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
                    .contains(string)
            }

            DispatchQueue.main.async {
                completion(SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList))
            }
        }
    }
}

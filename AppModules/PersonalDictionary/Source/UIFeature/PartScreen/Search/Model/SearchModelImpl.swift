//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class SearchModelImpl: SearchModel {

    private let searchableWordList: SearchableWordList

    init(searchableWordList: SearchableWordList) {
        self.searchableWordList = searchableWordList
    }

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData {
        let string = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if string.isEmpty {
            return SearchResultData(searchState: .initial, foundWordList: [])
        }

        let filteredWordList = mode == .bySourceWord ?
            searchableWordList.findWords(contain: string) :
            searchableWordList.findWords(whereTranslationContains: string)

        return SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList)
    }
}

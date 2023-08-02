//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class SearchWordListModelImpl: SearchWordListModel {

    private let searchableWordList: SearchableWordList

    init(searchableWordList: SearchableWordList) {
        self.searchableWordList = searchableWordList
    }

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData {
        let string = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if string.isEmpty {
            return SearchResultData(searchState: .initial, foundWordList: [])
        }

        var filteredWordList: [Word] = []

        switch mode {
        case .bySourceWord:
            filteredWordList = searchableWordList.findWords(contain: string)

        case .byTranslation:
            filteredWordList = searchableWordList.findWords(whereTranslationContains: string)
        }

        return SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList)
    }
}

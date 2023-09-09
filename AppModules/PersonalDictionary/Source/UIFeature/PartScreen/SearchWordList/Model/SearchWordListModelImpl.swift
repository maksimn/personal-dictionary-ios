//
//  WordListModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

struct SearchWordListModelImpl: SearchWordListModel {

    let searchableWordList: SearchableWordList
    let translationSearchableWordList: TranslationSearchableWordList

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
            filteredWordList = translationSearchableWordList.findWords(whereTranslationContains: string)
        }

        return SearchResultData(searchState: .fulfilled, foundWordList: filteredWordList)
    }
}

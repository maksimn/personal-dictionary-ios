//
//  SearchWordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 15.11.2022.
//

/// Search state
enum SearchState {
    case initial /// initial, search not performed.
    case fulfilled /// final, search completed.
}

/// Search result
struct SearchResultData: Equatable {

    /// Search state
    let searchState: SearchState

    /// List of found words
    let foundWordList: [Word]
}

protocol SearchWordListModel {

    func performSearch(for searchText: String, mode: SearchMode) -> SearchResultData
}

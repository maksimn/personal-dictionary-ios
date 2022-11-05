//
//  SearchResultData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Состояние поиска
enum SearchState {
    case initial /// начальное, поиск не выполнен.
    case fulfilled /// конечное, поиск выполнен.
}

/// Результат поиска
struct SearchResultData {

    /// Состояние поиска
    let searchState: SearchState

    /// Список найденных слов
    let foundWordList: [Word]
}

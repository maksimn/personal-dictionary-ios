//
//  SearchWordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 15.11.2022.
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

protocol SearchWordListModel: SearchInputListener { }

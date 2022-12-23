//
//  SearchModeViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Режим поиска
enum SearchMode {
    case bySourceWord /* по исходному слову */
    case byTranslation /* по переводу слова */
}

/// Модель представления выбора режима поиска.
protocol SearchModePickerViewModel: AnyObject {

    /// Режим поиска (данные модели представления).
    var searchMode: BindableSearchMode { get }
}

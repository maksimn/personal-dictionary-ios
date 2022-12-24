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

protocol SearchModePickerListener: AnyObject {

    func onSearchModeChanged(_ searchMode: SearchMode)
}

/// Модель представления выбора режима поиска.
protocol SearchModePickerViewModel: AnyObject {

    /// Режим поиска (данные модели представления).
    var searchMode: BindableSearchMode { get }

    var listener: SearchModePickerListener? { get set }
}

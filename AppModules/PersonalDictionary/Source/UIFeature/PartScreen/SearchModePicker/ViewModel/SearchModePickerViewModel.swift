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

/// Модель выбора режима поиска.
protocol SearchModePickerViewModel {

    var searchMode: BindableSeachMode { get }
}

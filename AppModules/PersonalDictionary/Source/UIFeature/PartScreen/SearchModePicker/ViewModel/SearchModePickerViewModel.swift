//
//  SearchModeViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import RxCocoa

typealias BindableSearchMode = BehaviorRelay<SearchMode>

/// Модель представления выбора режима поиска.
protocol SearchModePickerViewModel: AnyObject {

    /// Режим поиска (данные модели представления).
    var searchMode: BindableSearchMode { get }
}

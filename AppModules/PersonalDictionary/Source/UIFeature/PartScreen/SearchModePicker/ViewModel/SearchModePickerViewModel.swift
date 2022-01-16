//
//  SearchModeViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Модель представления выбора режима поиска.
protocol SearchModePickerViewModel: AnyObject {

    /// Режим поиска (данные модели представления).
    var searchMode: SearchMode? { get set }

    /// Обновить состояние модели режима поиска.
    /// - Parameters:
    ///  - searchMode: значение режима поиска.
    func update(_ searchMode: SearchMode)
}

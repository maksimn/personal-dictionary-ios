//
//  SearchModeView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Представление для выбора режима поиска.
protocol SearchModePickerView: AnyObject {

    /// Модель представления выбора режима поиска.
    var viewModel: SearchModePickerViewModel? { get set }

    /// Задать выбранный режим поиска в представлении.
    /// - Parameters:
    ///  - searchMode: режим поиска.
    func set(_ searchMode: SearchMode)
}

//
//  SearchModeModel.swift
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
protocol SearchModePickerModel: AnyObject {

    /// Модель представления выбора режима поиска.
    var viewModel: SearchModePickerViewModel? { get set }

    /// Делегат фичи "Выбор режима поиска".
    var listener: SearchModePickerListener? { get set }

    /// Получить режим поиска
    var searchMode: SearchMode { get }
}

/// Делегат фичи "Выбор режима поиска".
protocol SearchModePickerListener: AnyObject {

    /// Обработчик события изменения режима поиска.
    /// - Parameters:
    ///  - searchMode: режим поиска
    func onSearchModeChanged(_ searchMode: SearchMode)
}

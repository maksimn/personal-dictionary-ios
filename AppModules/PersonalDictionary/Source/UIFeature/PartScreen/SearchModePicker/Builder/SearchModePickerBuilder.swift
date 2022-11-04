//
//  SearchModeBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

/// Билдер фичи "Выбор режима поиска" по словам из словаря.
protocol SearchModePickerBuilder {

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> SearchModePickerGraph
}

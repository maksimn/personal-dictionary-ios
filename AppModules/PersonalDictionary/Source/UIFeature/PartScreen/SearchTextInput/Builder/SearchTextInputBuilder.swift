//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Билдер фичи "Элемент ввода поискового текста".
protocol SearchTextInputBuilder {

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> SearchTextInputGraph
}

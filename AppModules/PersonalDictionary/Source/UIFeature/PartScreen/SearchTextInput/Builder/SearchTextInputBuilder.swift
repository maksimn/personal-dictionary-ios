//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Билдер фичи "Элемент ввода поискового текста".
protocol SearchTextInputBuilder {

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> SearchTextInputMVVM
}

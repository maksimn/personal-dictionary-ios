//
//  LangPickerBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Билдер Фичи "Выбор языка".
protocol LangPickerBuilder {

    /// Создать MVVM-граф фичи.
    /// - Returns:
    ///  - Граф фичи "Выбор языка".
    func build() -> LangPickerGraph
}

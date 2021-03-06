//
//  WordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Билдер фичи "Список слов".
protocol WordListBuilder {

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM
}

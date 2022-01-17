//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

/// Билдер Фичи "Главный (основной) список слов" Личного словаря.
protocol MainWordListBuilder {

    /// Создать граф фичи.
    /// - Returns:
    ///  - Граф фичи  "Главный (основной) список слов".
    func build() -> MainWordListGraph
}

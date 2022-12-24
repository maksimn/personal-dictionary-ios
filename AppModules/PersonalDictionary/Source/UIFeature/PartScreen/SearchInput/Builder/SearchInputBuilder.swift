//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchInputBuilder {

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> SearchInputGraph
}
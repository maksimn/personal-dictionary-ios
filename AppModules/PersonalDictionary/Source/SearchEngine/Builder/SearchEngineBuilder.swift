//
//  SearchEngineBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

/// Билдер Фичи "Поисковый движок".
protocol SearchEngineBuilder {

    /// Создать объект поискового движка.
    /// - Returns: объект поискового движка.
    func build() -> SearchEngine
}

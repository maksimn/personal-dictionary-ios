//
//  ConfigBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

/// Билдер конфигурации приложения "Личный словарь".
protocol ConfigBuilder {

    /// Создать конфигурацию приложения.
    func build() -> AppConfigs

    /// Создать билдер Фичи "Главный/основной список слов".
    /// - Returns: билдер указанной фичи.
    func createMainWordListBuilder() -> MainWordListBuilder
}

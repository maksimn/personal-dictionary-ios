//
//  ConfigBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import CoreModule

/// Реализация билдера конфигурации приложения "Личный словарь".
final class ConfigBuilderImpl: ConfigBuilder {

    private let appParams: PersonalDictionaryAppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - appParams: внешние параметры приложения "Личный словарь".
    init(appParams: PersonalDictionaryAppParams) {
        self.appParams = appParams
    }

    /// Создать конфигурацию приложения.
    func build() -> AppConfigs {
        ConfigDependencies(appParams: appParams).appConfigs
    }

    /// Создать билдер Фичи "Главный/основной список слов".
    /// - Returns: билдер указанной фичи.
    func createMainWordListBuilder() -> MainWordListBuilder {
        MainWordListBuilderImpl(appConfigs: build())
    }
}

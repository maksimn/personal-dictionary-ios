//
//  PersonalDictionaryAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class PersonalDictionaryAppBuilderImpl: PersonalDictionaryAppBuilder {

    private let appParams: PersonalDictionaryAppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - appParams: внешние параметры для приложения.
    public init(appParams: PersonalDictionaryAppParams) {
        self.appParams = appParams
    }

    /// Создать объект данного приложения.
    /// - Returns:объект приложения.
    public func build() -> PersonalDictionaryApp {
        PersonalDictionaryAppImpl(configBuilder: ConfigBuilderImpl(appParams: appParams))
    }
}

//
//  AppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

/// Реализация билдера приложения "Личный словарь иностранных слов".
public final class AppBuilderImpl: AppBuilder {

    private let appParams: AppParams

    /// Инициализатор.
    /// - Parameters:
    ///  - appParams: внешние параметры для приложения.
    public init(appParams: AppParams) {
        self.appParams = appParams
    }

    /// Создать объект данного приложения.
    /// - Returns: объект приложения.
    public func build() -> App {
        AppImpl(appParams: appParams)
    }
}

//
//  PersonalDictionaryAppParams.swift
//  SuperList
//
//  Created by Maxim Ivanov on 20.12.2021.
//

import CoreModule

/// Внешние параметры для приложения "Личный словарь иностранных слов".
public struct PersonalDictionaryAppParams {

    public let coreRouter: CoreRouter?
    public let routingButtonTitle: String

    /// Инициализатор
    /// - Parameters:
    ///  - coreRouter: базовый роутер, предназначенный для навигации к другому Продукту (Приложению).
    ///  - routingButtonTitle: надпись для кнопки навигации к упомянутому другому Продукту.
    public init(coreRouter: CoreRouter?,
                routingButtonTitle: String) {
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
    }
}

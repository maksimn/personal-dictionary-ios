//
//  PersonalDictionaryAppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Реализация приложения "Личный словарь иностранных слов".
final class PersonalDictionaryAppImpl: PersonalDictionaryApp {

    /// Получение корневого контроллера приложения
    let navigationController: UINavigationController

    /// Инициализатор:
    /// - Parameters:
    ///  - configBuilder: билдер конфигурации данного приложения.
    init(configBuilder: ConfigBuilder) {
        let mainWordListBuilder = configBuilder.createMainWordListBuilder()
        let mainWordListGraph = mainWordListBuilder.build()
        navigationController = mainWordListGraph.navigationController ?? UINavigationController()
    }
}

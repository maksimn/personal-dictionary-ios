//
//  AppImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.12.2021.
//

import UIKit

/// Реализация приложения "Личный словарь иностранных слов".
final class AppImpl: App {

    /// Получение корневого контроллера приложения
    let navigationController: UINavigationController

    /// Инициализатор:
    /// - Parameters:
    ///  - config: конфигурация данного приложения.
    init(config: Config) {
        let mainWordListBuilder = MainWordListBuilderImpl(config: config)
        let mainWordListGraph = mainWordListBuilder.build()
        navigationController = mainWordListGraph.navigationController
    }
}

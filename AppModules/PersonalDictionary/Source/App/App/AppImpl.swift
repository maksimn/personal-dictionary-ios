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
    ///  - mainWordListBuilder: билдер Главного списка слов (главного экрана приложения).
    init(mainWordListBuilder: MainWordListBuilder) {
        navigationController = mainWordListBuilder.build()
    }
}

//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

/// Параметры конфигурации приложения "Личный словарь иностранных слов".
struct AppConfigs {

    /// Внешние параметры приложения
    let appParams: PersonalDictionaryAppParams

    /// Данные о языках в приложении
    let langData: LangData

    /// Ключ для запросов к Pons API для выполнения перевода слов
    let ponsApiSecret: String

    /// Флаг вкл/выкл логирование в приложении
    let isLoggingEnabled: Bool

    /// Конфигурация представлений в приложении ("тема")
    let appViewConfigs: AppViewConfigs
}

/// Конфигурация представлений в приложении ("тема")
struct AppViewConfigs {

    /// Цвет фона в приложении
    let backgroundColor: UIColor
}

//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

/// Параметры конфигурации приложения "Личный словарь иностранных слов".
struct Config {

    /// Данные о языках в приложении
    let langData: LangData

    /// Ключ для запросов к Pons API для выполнения перевода слов
    let ponsApiSecret: String

    /// Флаг вкл/выкл логирование в приложении
    let isLoggingEnabled: Bool
}

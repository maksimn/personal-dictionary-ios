//
//  Config.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

/// Параметры конфигурации приложения "Личный словарь иностранных слов".
struct AppConfig {

    /// Данные о языках в приложении
    let langData: LangData

    /// Ключ для запросов к Pons API для выполнения перевода слов
    let ponsApiSecret: String

    /// Время ежедневного пуш-уведомления
    let everydayPNTime: EverydayPNTime

    /// Время ежедневного пуш-уведомления
    struct EverydayPNTime {

        /// Часы
        let hours: Int

        /// Минуты
        let minutes: Int
    }
}
